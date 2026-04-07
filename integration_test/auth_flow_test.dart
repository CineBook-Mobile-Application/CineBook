import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cinebook/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    testWidgets('verify welcome screen and login navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // The Welcome Screen has 'Browse as Guest' (not 'Continue as Guest')
      final guestButton = find.text('Browse as Guest');
      expect(guestButton, findsOneWidget);

      // The welcome screen also has 'Get Started' to go to login
      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);

      // Tap 'Get Started' to navigate to Login screen
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify Login screen loaded by finding the Login button and email field
      final loginButton = find.text('Login');
      expect(loginButton, findsWidgets); // Login tab + Login button

      // Tap Login without credentials to trigger validation
      // Find the FilledButton specifically (the submit button)
      final filledButtons = find.byType(FilledButton);
      if (filledButtons.evaluate().isNotEmpty) {
        await tester.tap(filledButtons.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // The login screen shows a center popup with 'Validation Error' 
        // title and 'Please fill all fields' message when fields are empty
        expect(find.text('Please fill all fields'), findsOneWidget);
      }
    });
  });
}
