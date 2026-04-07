import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/core_models.dart';

class SeedService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> seedDatabase() async {
    final movies = [
      Movie(
        id: '1',
        title: 'Inception',
        genre: 'Action / Sci-Fi',
        duration: '2h 28min',
        rating: 8.8,
        posterUrl: 'assets/images/nowshowing/nowshowing/incepton.jpg',
        trailerImageUrl: 'assets/images/tailors/tailors/inception.jpg',
        youtubeVideoId: 'YoHD9XEInc0',
        synopsis: 'A thief who steals corporate secrets through the use of dream-sharing technology...',
        director: 'Christopher Nolan',
        cast: [{'name': 'Leonardo DiCaprio', 'role': 'Cobb'}, {'name': 'Joseph Gordon-Levitt', 'role': 'Arthur'}],
        language: 'English',
        ratingText: 'PG-13',
        isNowShowing: true,
      ),
      Movie(
        id: '2',
        title: 'Interstellar',
        genre: 'Adventure / Sci-Fi',
        duration: '2h 49min',
        rating: 8.7,
        posterUrl: 'assets/images/nowshowing/nowshowing/intesteller.jpg',
        trailerImageUrl: 'assets/images/tailors/tailors/interslellor.jpg',
        youtubeVideoId: 'zSWdZVtXT7E',
        synopsis: 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival...',
        director: 'Christopher Nolan',
        cast: [{'name': 'Matthew McConaughey', 'role': 'Cooper'}, {'name': 'Anne Hathaway', 'role': 'Brand'}],
        language: 'English',
        ratingText: 'PG-13',
        isNowShowing: true,
      ),
      Movie(
        id: '3',
        title: 'Joker',
        genre: 'Crime / Drama',
        duration: '2h 2min',
        rating: 8.4,
        posterUrl: 'assets/images/nowshowing/nowshowing/joker.jpg',
        trailerImageUrl: 'assets/images/tailors/tailors/Darknight.jpg',
        youtubeVideoId: 'zAGVQLHvwOY',
        synopsis: 'In Gotham City, mentally troubled comedian Arthur Fleck is disregarded and mistreated by society...',
        director: 'Todd Phillips',
        cast: [{'name': 'Joaquin Phoenix', 'role': 'Arthur Fleck'}, {'name': 'Robert De Niro', 'role': 'Murray Franklin'}],
        language: 'English',
        ratingText: 'R',
        isNowShowing: true,
      ),
      Movie(
        id: '4',
        title: 'Oppenheimer',
        genre: 'Biography / Drama',
        duration: '3h 0min',
        rating: 8.5,
        posterUrl: 'assets/images/nowshowing/nowshowing/open.jpg',
        trailerImageUrl: 'assets/images/tailors/tailors/openhimer.jpg',
        youtubeVideoId: 'uYPbbksJxIg',
        synopsis: 'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb...',
        director: 'Christopher Nolan',
        cast: [{'name': 'Cillian Murphy', 'role': 'J. Robert Oppenheimer'}, {'name': 'Emily Blunt', 'role': 'Kitty Oppenheimer'}],
        language: 'English',
        ratingText: 'R',
        isNowShowing: false,
      ),
    ];

    final cinemas = [
      Cinema(
        id: 'cin1',
        name: 'PVR Cinemas',
        location: 'One Galle Face Mall',
        distanceKm: 2.5,
        latitude: 6.9271,
        longitude: 79.8436,
        showtimes: [
          Showtime(id: 's1', time: '10:00 AM', format: '2D', price: 1000, availableSeats: 50, isFillingFast: false),
          Showtime(id: 's2', time: '01:30 PM', format: '3D', price: 1500, availableSeats: 12, isFillingFast: true),
        ],
      ),
      Cinema(
        id: 'cin2',
        name: 'Liberty Cinema',
        location: 'Colombo 03',
        distanceKm: 4.1,
        latitude: 6.9099,
        longitude: 79.8510,
        showtimes: [
          Showtime(id: 's3', time: '11:15 AM', format: '2D', price: 800, availableSeats: 100, isFillingFast: false),
          Showtime(id: 's4', time: '04:00 PM', format: '2D', price: 800, availableSeats: 45, isFillingFast: false),
        ],
      ),
      Cinema(
        id: 'cin3',
        name: 'Scope Cinemas - CCC',
        location: 'Colombo City Centre',
        distanceKm: 3.2,
        latitude: 6.9150,
        longitude: 79.8580,
        showtimes: [
          Showtime(id: 's5', time: '09:00 AM', format: 'IMAX', price: 2000, availableSeats: 5, isFillingFast: true),
        ],
      ),
      Cinema(
        id: 'cin4',
        name: 'Majestic Cineplex',
        location: 'Majestic City, Colombo 04',
        distanceKm: 5.5,
        latitude: 6.8939,
        longitude: 79.8547,
        showtimes: [
          Showtime(id: 's6', time: '10:30 AM', format: '2D', price: 900, availableSeats: 25, isFillingFast: false),
          Showtime(id: 's7', time: '06:00 PM', format: '3D', price: 1200, availableSeats: 8, isFillingFast: true),
        ],
      ),
      Cinema(
        id: 'cin5',
        name: 'Savoy 3D Cinema',
        location: 'Wellawatte, Colombo 06',
        distanceKm: 7.0,
        latitude: 6.8741,
        longitude: 79.8596,
        showtimes: [
          Showtime(id: 's8', time: '12:00 PM', format: '3D', price: 1000, availableSeats: 80, isFillingFast: false),
        ],
      ),
      Cinema(
        id: 'cin6',
        name: 'Regal Cinema',
        location: 'Fort, Colombo 01',
        distanceKm: 1.2,
        latitude: 6.9304,
        longitude: 79.8450,
        showtimes: [
          Showtime(id: 's9', time: '03:30 PM', format: '2D', price: 800, availableSeats: 40, isFillingFast: false),
        ],
      ),
      Cinema(
        id: 'cin7',
        name: 'KCC Multiplex',
        location: 'Kandy City Centre, Kandy',
        distanceKm: 115.0,
        latitude: 7.2936,
        longitude: 80.6380,
        showtimes: [
          Showtime(id: 's10', time: '01:00 PM', format: '2D', price: 800, availableSeats: 120, isFillingFast: false),
        ],
      ),
      Cinema(
        id: 'cin8',
        name: 'Queens Cinema',
        location: 'Galle',
        distanceKm: 119.0,
        latitude: 6.0367,
        longitude: 80.2170,
        showtimes: [
          Showtime(id: 's11', time: '04:30 PM', format: '2D', price: 700, availableSeats: 85, isFillingFast: false),
        ],
      ),
      Cinema(
        id: 'cin9',
        name: 'Vista Lite Cinema',
        location: 'Ja-Ela',
        distanceKm: 20.0,
        latitude: 7.0812,
        longitude: 79.8893,
        showtimes: [
          Showtime(id: 's12', time: '10:30 AM', format: '3D', price: 1000, availableSeats: 30, isFillingFast: true),
        ],
      ),
      Cinema(
        id: 'cin10',
        name: 'Suganthi Cinema',
        location: 'Jaffna',
        distanceKm: 395.0,
        latitude: 9.6645,
        longitude: 80.0167,
        showtimes: [
          Showtime(id: 's13', time: '06:00 PM', format: '2D', price: 600, availableSeats: 150, isFillingFast: false),
        ],
      ),
    ];

    // Write movies
    for (var movie in movies) {
      await _db.collection('movies').doc(movie.id).set(movie.toMap());
    }

    // Write cinemas
    for (var cinema in cinemas) {
      await _db.collection('cinemas').doc(cinema.id).set(cinema.toMap());
    }

    print('Database successfully seeded!');
  }
}
