import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cinebook/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Movie Browser Testing', () {
    testWidgets('verify toggle and movie card navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // First, navigate past Welcome Screen by tapping 'Browse as Guest'
      final guestButton = find.text('Browse as Guest');
      if (guestButton.evaluate().isNotEmpty) {
        await tester.tap(guestButton);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }

      // Now we should be on the Home Screen
      // Verify the Now Showing / Upcoming toggle buttons exist
      expect(find.text('Now Showing'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);

      // Toggle to Upcoming
      await tester.tap(find.text('Upcoming'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Toggle back to Now Showing
      await tester.tap(find.text('Now Showing'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Try to find and tap a movie card (Inception)
      final inceptionCard = find.text('Inception');
      if (inceptionCard.evaluate().isNotEmpty) {
        await tester.tap(inceptionCard);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify Movie Details screen loaded with 'Book Tickets' button
        expect(find.text('Book Tickets'), findsOneWidget);
      }
    });
  });
}
