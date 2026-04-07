import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  final String title;
  final String genre;
  final String duration;
  final double rating;
  final String posterUrl;
  final String synopsis;
  final bool isNowShowing;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.duration,
    required this.rating,
    required this.posterUrl,
    required this.synopsis,
    required this.isNowShowing,
  });

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Movie.fromMap(doc.id, data);
  }

  factory Movie.fromMap(String docId, Map<String, dynamic> data) {
    return Movie(
      id: docId,
      title: data['title'] ?? '',
      genre: data['genre'] ?? '',
      duration: data['duration'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      posterUrl: data['posterUrl'] ?? '',
      synopsis: data['synopsis'] ?? '',
      isNowShowing: data['isNowShowing'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'genre': genre,
      'duration': duration,
      'rating': rating,
      'posterUrl': posterUrl,
      'synopsis': synopsis,
      'isNowShowing': isNowShowing,
    };
  }
}

class Cinema {
  final String id;
  final String name;
  final String location;
  final double distanceKm;
  final double latitude;
  final double longitude;
  final List<Showtime> showtimes;

  Cinema({
    required this.id,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    required this.showtimes,
  });

  factory Cinema.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cinema.fromMap(doc.id, data);
  }

  factory Cinema.fromMap(String docId, Map<String, dynamic> data) {
    var showtimesList = data['showtimes'] as List? ?? [];
    List<Showtime> parsedShowtimes = showtimesList
        .map((e) => Showtime.fromMap(e['id'] ?? '', e as Map<String, dynamic>))
        .toList();

    return Cinema(
      id: docId,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      distanceKm: (data['distanceKm'] ?? 0.0).toDouble(),
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      showtimes: parsedShowtimes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'distanceKm': distanceKm,
      'latitude': latitude,
      'longitude': longitude,
      'showtimes': showtimes.map((s) => s.toMap()).toList(),
    };
  }
}

class Showtime {
  final String id;
  final String time;
  final String format; // 2D, 3D, IMAX
  final double price;
  final int availableSeats;
  final bool isFillingFast;

  Showtime({
    required this.id,
    required this.time,
    required this.format,
    required this.price,
    required this.availableSeats,
    this.isFillingFast = false,
  });

  factory Showtime.fromMap(String docId, Map<String, dynamic> data) {
    return Showtime(
      id: docId,
      time: data['time'] ?? '',
      format: data['format'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      availableSeats: data['availableSeats'] ?? 0,
      isFillingFast: data['isFillingFast'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'format': format,
      'price': price,
      'availableSeats': availableSeats,
      'isFillingFast': isFillingFast,
    };
  }
}

class Ticket {
  final String id;
  final String userId;
  final Movie movie;
  final Cinema cinema;
  final Showtime showtime;
  final DateTime date;
  final List<String> seatNumbers;
  final double totalAmount;
  final bool isActive;
  final String status;
  final bool isSplitPayment;
  final List<String> splitWithEmails;

  Ticket({
    required this.id,
    required this.userId,
    required this.movie,
    required this.cinema,
    required this.showtime,
    required this.date,
    required this.seatNumbers,
    required this.totalAmount,
    this.isActive = true,
    this.status = 'Valid',
    this.isSplitPayment = false,
    this.splitWithEmails = const [],
  });

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Ticket.fromMap(doc.id, data);
  }

  factory Ticket.fromMap(String docId, Map<String, dynamic> data) {
    return Ticket(
      id: docId,
      userId: data['userId'] ?? '',
      movie: Movie.fromMap(data['movie']?['id'] ?? '', data['movie'] ?? {}),
      cinema: Cinema.fromMap(data['cinema']?['id'] ?? '', data['cinema'] ?? {}),
      showtime: Showtime.fromMap(data['showtime']?['id'] ?? '', data['showtime'] ?? {}),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      seatNumbers: List<String>.from(data['seatNumbers'] ?? []),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      isActive: data['isActive'] ?? true,
      status: data['status'] ?? 'Valid',
      isSplitPayment: data['isSplitPayment'] ?? false,
      splitWithEmails: List<String>.from(data['splitWithEmails'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'movie': movie.toMap()..['id'] = movie.id,
      'cinema': cinema.toMap()..['id'] = cinema.id,
      'showtime': showtime.toMap(),
      'date': Timestamp.fromDate(date),
      'seatNumbers': seatNumbers,
      'totalAmount': totalAmount,
      'isActive': isActive,
      'status': status,
      'isSplitPayment': isSplitPayment,
      'splitWithEmails': splitWithEmails,
    };
  }
}

class Payment {
  final String id;
  final String ticketId;
  final String userId;
  final String authorName;
  final String date;
  final String time;
  final double amount;
  final String status;
  final String encryptedCardData;
  final DateTime timestamp;

  Payment({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.authorName,
    required this.date,
    required this.time,
    required this.amount,
    required this.status,
    required this.encryptedCardData,
    required this.timestamp,
  });

  factory Payment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Payment.fromMap(doc.id, data);
  }

  factory Payment.fromMap(String docId, Map<String, dynamic> data) {
    return Payment(
      id: docId,
      ticketId: data['ticketId'] ?? '',
      userId: data['userId'] ?? '',
      authorName: data['authorName'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'Pending',
      encryptedCardData: data['encryptedCardData'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'userId': userId,
      'authorName': authorName,
      'date': date,
      'time': time,
      'amount': amount,
      'status': status,
      'encryptedCardData': encryptedCardData,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
