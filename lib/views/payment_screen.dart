import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinebook/core/app_colors.dart';
import 'package:cinebook/models/core_models.dart';
import 'package:cinebook/services/database_service.dart';
import 'package:cinebook/services/payment_gateway_service.dart';

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
      final splitEmails = widget.checkoutData['splitEmails'] as List<String>? ?? [];

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
        splitWithEmails: isSplitPayment ? splitEmails : [],
      );

      final paymentService = PaymentGatewayService();
      await paymentService.processPayment(
        ticketId: ticketRef.id,
        userId: userId,
        cardNumber: _cardNumberController.text,
        expiry: _expiryController.text,
        cvv: _cvvController.text,
        name: _nameController.text,
        amount: totalPrice.toDouble(),
      );

      await DatabaseService().bookTicket(ticket);

      if (mounted) {
        Navigator.pop(context);
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
        Navigator.pop(context);
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

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Complete Payment'),
        backgroundColor: colorScheme.surface,
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
                      Expanded(flex: 2, child: _buildOrderSummary(totalAmount.toDouble())),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildOrderSummary(totalAmount.toDouble()),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.circle),
                child: Icon(Icons.fast_forward, color: colorScheme.onPrimaryContainer, size: 20),
              ),
              const SizedBox(width: 12),
              Text('CinePay Gateway', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
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
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              onPressed: _processFinalPayment,
              child: const Text('Pay Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: colorScheme.onSurface)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(color: colorScheme.onSurface),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, color: colorScheme.primary) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(double totalAmount) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
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
            children: [
              Text('Company', style: TextStyle(color: colorScheme.onSurfaceVariant)),
              Text('CineBook Cinemas', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Service Fee', style: TextStyle(color: colorScheme.onSurfaceVariant)),
              Text('LKR 0.00', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('You have to Pay', style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant)),
                Text(
                  'LKR ${totalAmount.toInt()}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVirtualCard() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.15),
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
            style: TextStyle(color: colorScheme.onPrimary, fontSize: 18, letterSpacing: 2, fontFamily: 'Courier'),
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Card Holder', style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.7), fontSize: 10)),
                  Text(_displayName, style: TextStyle(color: colorScheme.onPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expires', style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.7), fontSize: 10)),
                  Text(_displayExpiry, style: TextStyle(color: colorScheme.onPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
