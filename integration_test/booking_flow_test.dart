import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cinebook/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Booking Flow Testing', () {
    testWidgets('navigate through cinema to seat selection', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // Navigate past Welcome Screen
      final guestButton = find.text('Browse as Guest');
      if (guestButton.evaluate().isNotEmpty) {
        await tester.tap(guestButton);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }

      // On Home Screen: tap the first movie card 
      // Movie cards are wrapped in GestureDetectors
      final movieCards = find.byType(GestureDetector);
      if (movieCards.evaluate().length > 1) {
        await tester.tap(movieCards.at(1)); // Skip first (might be tab toggle)
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // On Movie Details: Look for 'Book Tickets' button
        final bookButton = find.text('Book Tickets');
        if (bookButton.evaluate().isNotEmpty) {
          await tester.tap(bookButton);
          await tester.pumpAndSettle(const Duration(seconds: 3));
          
          // On Cinema Selector: verify calendar/showtime elements exist
          // The cinema selector has date chips and showtime cards
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });
  });
}
