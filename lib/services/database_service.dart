import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/core_models.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch movies stream
  Stream<List<Movie>> getMoviesStream() {
    return _db.collection('movies').limit(50).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Movie.fromFirestore(doc))
              .toList(),
        );
  }

  // Fetch cinemas future with caching (Optimized for Map)
  Future<List<Cinema>> getCinemas() async {
    final snapshot = await _db.collection('cinemas').get(const GetOptions(source: Source.serverAndCache));
    return snapshot.docs.map((doc) => Cinema.fromFirestore(doc)).toList();
  }

  // Process checkout securely using atomic transaction
  Future<void> processCheckout(Ticket ticket, Payment payment) async {
    final ticketRef = ticket.id.isEmpty 
        ? _db.collection('tickets').doc() 
        : _db.collection('tickets').doc(ticket.id);
        
    final updatedTicket = ticket.id.isEmpty 
        ? Ticket.fromMap(ticketRef.id, ticket.toMap()) 
        : ticket;
        
    final paymentRef = _db.collection('payments').doc(payment.id);
    final cinemaRef = _db.collection('cinemas').doc(ticket.cinema.id);

    await _db.runTransaction((transaction) async {
      // 1. Read current cinema availability
      final cinemaSnapshot = await transaction.get(cinemaRef);
      if (!cinemaSnapshot.exists) throw Exception("Cinema does not exist!");

      final cinema = Cinema.fromFirestore(cinemaSnapshot);
      final showtimeIndex = cinema.showtimes.indexWhere((s) => s.id == ticket.showtime.id);
      
      if (showtimeIndex == -1) throw Exception("Showtime not found!");
      
      final showtime = cinema.showtimes[showtimeIndex];
      final seatCountToBook = ticket.seatNumbers.length;
      
      if (showtime.availableSeats < seatCountToBook) {
        throw Exception("Not enough available seats left!");
      }

      // 2. Modify available seats
      final updatedShowtime = Showtime(
        id: showtime.id,
        time: showtime.time,
        format: showtime.format,
        price: showtime.price,
        availableSeats: showtime.availableSeats - seatCountToBook,
        isFillingFast: (showtime.availableSeats - seatCountToBook) < 20,
      );
      
      cinema.showtimes[showtimeIndex] = updatedShowtime;

      // 3. Write updates atomically
      transaction.update(cinemaRef, {'showtimes': cinema.showtimes.map((s) => s.toMap()).toList()});
      transaction.set(ticketRef, updatedTicket.toMap());
      transaction.set(paymentRef, payment.toMap());
    });
  }

  // Get user profile
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromFirestore(doc);
    }
    return null;
  }

  // Get user's tickets
  Stream<List<Ticket>> getUserTicketsStream(String userId) {
    return _db
        .collection('tickets')
        .where('userId', isEqualTo: userId)
        // .orderBy('date', descending: true) // Requires composite index if filtering by userId
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Ticket.fromFirestore(doc))
              .toList(),
        );
  }
}
