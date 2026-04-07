import 'encryption_service.dart';

import '../models/core_models.dart';
import 'database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentGatewayService {
  Future<Payment> processPayment({
    required String ticketId,
    required String userId,
    required String cardNumber,
    required String expiry,
    required String cvv,
    required String name,
    required double amount,
  }) async {
    // 1. Simulate network and bank processing delay
    await Future.delayed(const Duration(seconds: 2));

    // 2. Validate mock data
    if (cardNumber.replaceAll(' ', '').length < 15 || cvv.length < 3) {
      throw Exception("Invalid Card Details. Please verify your card number and CVV.");
    }

    // 3. Encrypt highly sensitive data before ever touching the database
    final sensitivePayload = '$cardNumber|$expiry|$cvv|$name';
    final encryptedData = EncryptionService.encryptData(sensitivePayload);

    // 4. Generate Payment Record Object
    final paymentRef = FirebaseFirestore.instance.collection('payments').doc();
    final payment = Payment(
      id: paymentRef.id,
      ticketId: ticketId,
      userId: userId,
      authorName: name,
      date: '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
      time: '${DateTime.now().hour}:${DateTime.now().minute}',
      amount: amount,
      status: 'Success',
      encryptedCardData: encryptedData,
      timestamp: DateTime.now(),
    );


    // 5. Store encrypted record securely in Database
    await DatabaseService().savePayment(payment);
    
    return payment;
  }
}