import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/core_models.dart';

class DatabaseService {
  // Singleton pattern
  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch movies stream
  Stream<List<Movie>> getMoviesStream() {
    return _db.collection('movies').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Movie.fromFirestore(doc))
              .toList(),
        );
  }

  // Fetch cinemas stream
  Stream<List<Cinema>> getCinemasStream() {
    return _db.collection('cinemas').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Cinema.fromFirestore(doc))
              .toList(),
        );
  }

  // Book a ticket (write to Firestore)
  Future<void> bookTicket(Ticket ticket) async {
    // If ticket.id is empty, Firestore will generate one, but we generate it locally or pass an empty string
    final docRef = ticket.id.isEmpty 
        ? _db.collection('tickets').doc() 
        : _db.collection('tickets').doc(ticket.id);
        
    await docRef.set(ticket.toMap());
  }

  // Book a payment record securely
  Future<void> savePayment(Payment payment) async {
    final docRef = _db.collection('payments').doc(payment.id);
    await docRef.set(payment.toMap());
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
