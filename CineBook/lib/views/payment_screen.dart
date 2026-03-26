import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/app_colors.dart';
import '../models/core_models.dart';
import '../services/database_service.dart';
import '../services/payment_gateway_service.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> checkoutData;
  const PaymentScreen({Key? key, required this.checkoutData}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  String _displayCardNumber = '****  ****  ****  3456';
  String _displayName = 'ADUKE MOREWA';
  String _displayExpiry = '09/24';

  @override
  void initState() {
    super.initState();
    // Add real-time listeners for dynamic Virtual Card rendering
    _cardNumberController.addListener(() {
      setState(() {
        _displayCardNumber = _cardNumberController.text.isNotEmpty 
            ? _cardNumberController.text 
            : '****  ****  ****  3456';
      });
    });
    
    _nameController.addListener(() {
      setState(() {
        _displayName = _nameController.text.isNotEmpty 
            ? _nameController.text.toUpperCase() 
            : 'ADUKE MOREWA';
      });
    });
    
    _expiryController.addListener(() {
      setState(() {
        _displayExpiry = _expiryController.text.isNotEmpty 
            ? _expiryController.text 
            : '09/24';
      });
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _processFinalPayment() async {
    // 1. Strict Form Validation checks before networking
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final showtime = widget.checkoutData['showtime'] as Showtime;
      final cinema = widget.checkoutData['cinema'] as Cinema;
      final movieId = widget.checkoutData['movieId'] as String;
      final selectedSeats = widget.checkoutData['selectedSeats'] as List<String>;
      final isSplitPayment = widget.checkoutData['isSplitPayment'] as bool;
      final splitEmail = widget.checkoutData['splitEmail'] as String;

      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

      final movieDoc = await FirebaseFirestore.instance.collection('movies').doc(movieId).get();
      if (!movieDoc.exists) throw Exception('Movie not found');
      final movie = Movie.fromFirestore(movieDoc);

      final totalPrice = selectedSeats.length * showtime.price;

      final ticketRef = FirebaseFirestore.instance.collection('tickets').doc();
      final ticket = Ticket(
        id: ticketRef.id,
        userId: userId,
        movie: movie,
        cinema: cinema,
        showtime: showtime,
        date: DateTime.now(),
        seatNumbers: selectedSeats,
        totalAmount: totalPrice.toDouble(),
        isActive: true,
        status: isSplitPayment ? 'Pending Split Payment' : 'Valid',
        isSplitPayment: isSplitPayment,
        splitWithEmails: isSplitPayment ? [splitEmail] : [],
      );

      // 2. Process secure transaction through Mock Payment Gateway
      final paymentService = PaymentGatewayService();
      final payment = await paymentService.processPayment(
        ticketId: ticketRef.id,
        userId: userId,
        cardNumber: _cardNumberController.text,
        expiry: _expiryController.text,
        cvv: _cvvController.text,
        name: _nameController.text,
        amount: totalPrice.toDouble(),
      );

      // 3. Insert ticket and payment atomically into Firebase database!
      await DatabaseService().processCheckout(ticket, payment);

      if (mounted) {
        Navigator.pop(context); // remove loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isSplitPayment
                ? 'Invites sent! Ticket marked as pending payment.'
                : 'Payment Successful! Ticket generated.'),
            backgroundColor: Colors.green,
          ),
        );
        context.pushReplacement('/ticket-details', extra: ticket);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // remove loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bank Declined: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showtime = widget.checkoutData['showtime'] as Showtime;
    final selectedSeats = widget.checkoutData['selectedSeats'] as List<String>;
    final totalAmount = selectedSeats.length * showtime.price;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complete Payment', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildPaymentForm()),
                      const SizedBox(width: 48),
                      Expanded(flex: 2, child: _buildOrderSummary(totalAmount)),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildOrderSummary(totalAmount),
                    const SizedBox(height: 32),
                    _buildPaymentForm(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.fast_forward, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('CinePay Gateway', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 32),
          _buildTextField(
            'Cardholder Name', 
            'Aduke Morewa', 
            _nameController, 
            icon: Icons.person_outline,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Please enter the exact name on card';
              return null;
            }
          ),
          const SizedBox(height: 20),
          _buildTextField(
            'Card Number', 
            '0000 0000 0000 0000', 
            _cardNumberController, 
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.replaceAll(' ', '').length < 15) return 'Please enter a valid 16-digit card number';
              return null;
            }
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  'Expiry Date', 
                  'MM/YY', 
                  _expiryController, 
                  icon: Icons.date_range,
                  keyboardType: TextInputType.datetime,
                  validator: (val) {
                    if (val == null || !RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(val)) return 'Invalid Expiry';
                    return null;
                  }
                )
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildTextField(
                  'CVV', 
                  '123', 
                  _cvvController, 
                  icon: Icons.security, 
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.length < 3) return 'Invalid CVV';
                    return null;
                  }
                )
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              onPressed: _processFinalPayment,
              child: const Text('Pay Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, 
    String hint, 
    TextEditingController controller, 
    {
      IconData? icon, 
      bool obscureText = false,
      String? Function(String?)? validator,
      TextInputType? keyboardType,
    }
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.textPrimary),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
            filled: true,
            fillColor: AppColors.cardColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVirtualCard(),
          const SizedBox(height: 32),
          const Divider(color: Colors.black12),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Company', style: TextStyle(color: AppColors.textSecondary)),
              Text('CineBook Cinemas', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Service Fee', style: TextStyle(color: AppColors.textSecondary)),
              Text('LKR 0.00', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('You have to Pay', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                Text(
                  'LKR ${totalAmount.toInt()}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Virtual Card dynamically updates using State Variables
  Widget _buildVirtualCard() {
    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.memory, color: Colors.yellow.shade600, size: 32),
              const Icon(Icons.wifi, color: Colors.white70),
            ],
          ),
          Text(
            _displayCardNumber,
            style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2, fontFamily: 'Courier'),
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Card Holder', style: TextStyle(color: Colors.white54, fontSize: 10)),
                  Text(_displayName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expires', style: TextStyle(color: Colors.white54, fontSize: 10)),
                  Text(_displayExpiry, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
