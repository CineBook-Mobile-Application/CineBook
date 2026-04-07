import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cinebook/views/payment_screen.dart';
import 'package:cinebook/models/core_models.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Payment Validation Testing', () {
    testWidgets('verify virtual card fields catch invalid inputs',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PaymentScreen(
            checkoutData: {
              'movieId': '1',
              'cinemaName': 'Test Cinema',
              'totalPrice': 2000.0,
              'selectedSeats': const ['A1', 'A2'],
              'showtime': Showtime(
                id: '1',
                time: '10:00 AM',
                format: '2D',
                price: 1000.0,
                availableSeats: 50,
              ),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The actual button text in payment_screen.dart is 'Pay Now'
      final payButton = find.text('Pay Now');
      expect(payButton, findsOneWidget);

      await tester.tap(payButton);
      await tester.pumpAndSettle();

      // Validation messages from payment_screen.dart validators:
      // Name: 'Please enter the exact name on card'
      // Card: 'Please enter a valid 16-digit card number'
      // Expiry: 'Invalid Expiry'
      // CVV: 'Invalid CVV'
      expect(find.textContaining('Please enter'), findsWidgets);
    });
  });
}
