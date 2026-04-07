import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_colors.dart';
import '../models/core_models.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Map<String, dynamic>? bookingData; // Getting booking bundle
  const SeatSelectionScreen({Key? key, this.bookingData}) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Set<String> _selectedSeats = {};
  
  // Mock seat generation
  final int rows = 8;
  final int cols = 8;
  final Set<String> _bookedSeats = {'C4', 'C5', 'D4', 'E2'};

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Select Seats'),
        backgroundColor: colorScheme.surface,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Screen Curve Marker
          CustomPaint(
            size: const Size(300, 30),
            painter: ScreenPainter(),
          ),
          const SizedBox(height: 16),
          const Text('SCREEN', style: TextStyle(color: AppColors.textSecondary, letterSpacing: 4)),
          const SizedBox(height: 32),
          
          Expanded(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 2.5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: rows * cols,
                    itemBuilder: (context, index) {
                      final row = String.fromCharCode(65 + (index ~/ cols));
                      final col = (index % cols) + 1;
                      final seatId = '$row$col';

                      // Create a gap in the middle
                      if (col == 4 || col == 5) {
                        return const SizedBox.shrink(); // Aisle
                      }

                      final isBooked = _bookedSeats.contains(seatId);
                      final isSelected = _selectedSeats.contains(seatId);

                      return FilterChip(
                        label: Text(
                          seatId,
                          style: TextStyle(
                            fontSize: 10,
                            color: isBooked
                                ? colorScheme.onSurfaceVariant.withOpacity(0.5)
                                : isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: isBooked
                            ? null
                            : (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedSeats.add(seatId);
                                  } else {
                                    _selectedSeats.remove(seatId);
                                  }
                                });
                              },
                        showCheckmark: false,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                        backgroundColor: colorScheme.surface,
                        selectedColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isBooked ? Colors.transparent : colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(colorScheme.surface, 'Available', border: true, borderColor: colorScheme.primary),
              const SizedBox(width: 16),
              _buildLegendItem(colorScheme.primary, 'Selected'),
              const SizedBox(width: 16),
              _buildLegendItem(colorScheme.surfaceVariant, 'Booked'),
            ],
          ),
          const SizedBox(height: 16),
          
          // AR Entry Point
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                // Show AR preview with the first selected seat or default to 'C4'
                final selectedSeat = _selectedSeats.isNotEmpty ? _selectedSeats.first : 'C4';
                context.push('/ar-view', extra: {'selectedSeat': selectedSeat});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.tertiary]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.view_in_ar, color: colorScheme.onPrimary),
                    const SizedBox(width: 8),
                    Text('AR View from My Seat', style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [BoxShadow(color: colorScheme.shadow.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Price', style: TextStyle(color: AppColors.textSecondary)),
                          Text(
                            'LKR ${(_selectedSeats.length * (widget.bookingData?['showtime']?.price ?? 1000)).toInt()}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                      FilledButton(
                        onPressed: _selectedSeats.isEmpty
                            ? null
                            : () => _showPaymentOptions(context),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text('Proceed'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {bool border = false, Color? borderColor}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: border ? Border.all(color: borderColor ?? AppColors.primary) : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Payment Mode', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Choose how you want to pay for this booking.', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              
              // Group Split-Payment Option
              if (_selectedSeats.length > 1) ...[
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSplitPaymentDialog(context);
                  },
                  icon: const Icon(Icons.group, color: AppColors.primary),
                  label: const Text('Group Split-Payment', style: TextStyle(color: AppColors.primary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Pay Now
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Close bottom payment sheet
                  _processBooking(isSplitPayment: false);
                },
                icon: const Icon(Icons.payment, color: Colors.white),
                label: const Text('Pay Full Amount', style: TextStyle(color: Colors.white)),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSplitPaymentDialog(BuildContext context) {
<<<<<<< HEAD:lib/views/seat_selection_screen.dart
    final int splitCount = _selectedSeats.length - 1;
    final List<TextEditingController> emailControllers = List.generate(
      splitCount,
      (_) => TextEditingController(),
=======
    final int seatCount = _selectedSeats.length;
    final List<TextEditingController> controllers = List.generate(
      seatCount, 
      (i) => TextEditingController(
        text: (i == 0) ? (FirebaseAuth.instance.currentUser?.email ?? '') : ''
      )
>>>>>>> pr/5:CineBook/lib/views/seat_selection_screen.dart
    );
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
<<<<<<< HEAD:lib/views/seat_selection_screen.dart
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Split Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter the emails of the $splitCount friend(s) you want to split this booking with.', style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                ...List.generate(splitCount, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      controller: emailControllers[index],
                      decoration: InputDecoration(
                        labelText: "Friend ${index + 1}'s Email",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  );
                }),
              ],
            ),
=======
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.group_add_rounded, color: AppColors.primary),
              const SizedBox(width: 12),
              const Text('Split Payment', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
>>>>>>> pr/5:CineBook/lib/views/seat_selection_screen.dart
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter emails for all $seatCount selected seats. Each person will receive an invite to pay their share.',
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(seatCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                          labelText: index == 0 ? "Your Email (Initiator)" : "Friend ${index}'s Email",
                          hintText: "example@email.com",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: Icon(index == 0 ? Icons.person : Icons.email_outlined, color: AppColors.primary),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
<<<<<<< HEAD:lib/views/seat_selection_screen.dart
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final List<String> emails = [];
                for (var controller in emailControllers) {
                  final email = controller.text.trim();
                  if (email.isEmpty || !email.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid emails for everyone')));
                    return;
                  }
                  emails.add(email);
=======
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final emails = controllers.map((c) => c.text.trim()).toList();
                
                // Validate all emails
                for (var email in emails) {
                  if (email.isEmpty || !email.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter valid emails for all seats. (Missing: $email)'))
                    );
                    return;
                  }
>>>>>>> pr/5:CineBook/lib/views/seat_selection_screen.dart
                }

                Navigator.pop(context); // Close dialog
                _processBooking(isSplitPayment: true, splitEmails: emails);
              },
<<<<<<< HEAD:lib/views/seat_selection_screen.dart
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Send Invites', style: TextStyle(color: Colors.white)),
=======
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Send Invites', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
>>>>>>> pr/5:CineBook/lib/views/seat_selection_screen.dart
            ),
          ],
        );
      }
    );
  }

  void _processBooking({required bool isSplitPayment, List<String> splitEmails = const []}) {
    if (widget.bookingData == null) return;
    if (_selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one seat!')));
      return;
    }

    final checkoutData = {
      ...widget.bookingData!,
      'selectedSeats': _selectedSeats.toList(),
      'isSplitPayment': isSplitPayment,
      'splitEmails': splitEmails,
    };

    context.push('/payment', extra: checkoutData);
  }
}

class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
