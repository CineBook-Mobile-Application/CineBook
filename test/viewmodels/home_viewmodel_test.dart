import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cinebook/services/database_service.dart';
import 'package:cinebook/services/seed_service.dart';
import 'package:cinebook/viewmodels/home_viewmodel.dart';
import 'package:cinebook/models/core_models.dart';
import 'dart:async';

// Generate Mock classes
@GenerateMocks([DatabaseService, SeedService])
import 'home_viewmodel_test.mocks.dart';

void main() {
  late HomeViewModel viewModel;
  late MockDatabaseService mockDatabaseService;
  late MockSeedService mockSeedService;
  late StreamController<List<Movie>> movieStreamController;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockSeedService = MockSeedService();
    movieStreamController = StreamController<List<Movie>>.broadcast();

    // Default: return empty list, and the stream
    when(mockDatabaseService.getMoviesStream())
        .thenAnswer((_) => movieStreamController.stream);

    viewModel = HomeViewModel(
      databaseService: mockDatabaseService,
      seedService: mockSeedService,
    );
  });

  tearDown(() {
    movieStreamController.close();
  });

  group('HomeViewModel Tests', () {
    test('Initial loading state is true while stream is starting', () {
      expect(viewModel.isLoading, true);
    });

    test('movie list update sets isLoading to false', () async {
      final mockMovies = [
        Movie(id: '1', title: 'Inception', isNowShowing: true, rating: 9.0, genre: 'Sci-Fi', duration: '148 min', posterUrl: '', synopsis: '', director: '', cast: [], language: 'English', ratingText: 'PG-13'),
      ];
      
      movieStreamController.add(mockMovies);
      
      // Wait for a tick
      await Future.delayed(Duration.zero);

      expect(viewModel.isLoading, false);
      expect(viewModel.currentMovies.length, 1);
      expect(viewModel.currentMovies.first.title, 'Inception');
    });

    test('Empty movie list triggers auto-seeding', () async {
      movieStreamController.add([]); // Add empty list
      
      await Future.delayed(Duration.zero);
      
      verify(mockSeedService.seedDatabase()).called(1);
    });

    test('toggleMovieType correctly filters movies', () async {
      final mockMovies = [
        Movie(id: '1', title: 'Movie 1', isNowShowing: true, rating: 8.0, genre: 'Action', duration: '100 min', posterUrl: '', synopsis: '', director: '', cast: [], language: 'English', ratingText: 'G'),
        Movie(id: '2', title: 'Movie 2', isNowShowing: false, rating: 7.0, genre: 'Drama', duration: '120 min', posterUrl: '', synopsis: '', director: '', cast: [], language: 'English', ratingText: 'PG'),
      ];
      
      movieStreamController.add(mockMovies);
      await Future.delayed(Duration.zero);

      expect(viewModel.showNowShowing, true);
      expect(viewModel.currentMovies.length, 1);
      expect(viewModel.currentMovies.first.title, 'Movie 1');

      viewModel.toggleMovieType(false);
      
      expect(viewModel.showNowShowing, false);
      expect(viewModel.currentMovies.length, 1);
      expect(viewModel.currentMovies.first.title, 'Movie 2');
    });

    test('cancel subscription on dispose', () {
      viewModel.dispose();
    });
  });
}
