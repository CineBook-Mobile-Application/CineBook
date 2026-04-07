import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinebook/services/auth_service.dart';
import 'package:cinebook/viewmodels/auth_viewmodel.dart';

// Generate a MockAuthService using mockito
@GenerateMocks([AuthService])
import 'auth_viewmodel_test.mocks.dart';

void main() {
  late AuthViewModel viewModel;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    viewModel = AuthViewModel(authService: mockAuthService);
  });

  group('AuthViewModel Tests', () {
    test('Initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('login success updates state correctly', () async {
      when(mockAuthService.signIn(any, any))
          .thenAnswer((_) async => null); // Mock returns Future<User?>

      final result = await viewModel.login('test@example.com', 'password123');

      expect(result, true);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      verify(mockAuthService.signIn('test@example.com', 'password123')).called(1);
    });

    test('login failure updates errorMessage', () async {
      when(mockAuthService.signIn(any, any))
          .thenThrow(FirebaseAuthException(code: 'user-not-found', message: 'No user found.'));

      final result = await viewModel.login('wrong@example.com', 'password');

      expect(result, false);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, 'No user found.');
    });

    test('logout calls signOut', () async {
      await viewModel.logout();
      verify(mockAuthService.signOut()).called(1);
    });
  });
}
