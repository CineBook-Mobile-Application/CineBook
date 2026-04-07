import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/app_colors.dart';
import '../models/core_models.dart';
import '../services/database_service.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Map<String, dynamic>? bookingData;
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
    const Color logoYellow = Color(0xFFFFC107);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Select Seats'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Screen Curve Marker
          CustomPaint(
            size: const Size(300, 30),
            painter: ScreenPainter(color: colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text('SCREEN', style: TextStyle(color: colorScheme.onSurfaceVariant, letterSpacing: 4, fontSize: 12, fontWeight: FontWeight.bold)),
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

                      // Create a gap in the middle (Aisle)
                      if (col == 4 || col == 5) {
                        return const SizedBox.shrink();
                      }

                      final isBooked = _bookedSeats.contains(seatId);
                      final isSelected = _selectedSeats.contains(seatId);

                      return GestureDetector(
                        onTap: isBooked ? null : () {
                          setState(() {
                            if (isSelected) {
                              _selectedSeats.remove(seatId);
                            } else {
                              _selectedSeats.add(seatId);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isBooked 
                                ? colorScheme.surfaceVariant
                                : isSelected 
                                    ? colorScheme.primary 
                                    : colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isBooked 
                                  ? Colors.transparent 
                                  : isSelected 
                                      ? colorScheme.primary 
                                      : colorScheme.primary.withOpacity(0.3),
                            ),
                            boxShadow: isSelected 
                                ? [BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              seatId,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isBooked
                                    ? colorScheme.onSurfaceVariant.withOpacity(0.4)
                                    : isSelected
                                        ? colorScheme.onPrimary
                                        : colorScheme.primary,
                              ),
                            ),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(context, colorScheme.surface, 'Available', border: true, borderColor: colorScheme.primary.withOpacity(0.3)),
                const SizedBox(width: 24),
                _buildLegendItem(context, colorScheme.primary, 'Selected'),
                const SizedBox(width: 24),
                _buildLegendItem(context, colorScheme.surfaceVariant, 'Booked'),
              ],
            ),
          ),
          
          // AR Entry Point
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: InkWell(
              onTap: () {
                final selectedSeat = _selectedSeats.isNotEmpty ? _selectedSeats.first : 'C4';
                context.push('/ar-view', extra: {'selectedSeat': selectedSeat});
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    const Text('AR View from My Seat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [BoxShadow(color: colorScheme.shadow.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -5))],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Price', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                            'LKR ${(_selectedSeats.length * (widget.bookingData?['showtime']?.price ?? 1000)).toInt()}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.primary),
                          ),
                        ],
                      ),
                      FilledButton(
                        onPressed: _selectedSeats.isEmpty
                            ? null
                            : () => _showPaymentOptions(context),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Proceed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _buildLegendItem(BuildContext context, Color color, String label, {bool border = false, Color? borderColor}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: border ? Border.all(color: borderColor ?? colorScheme.primary) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showPaymentOptions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Payment Mode', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
              const SizedBox(height: 12),
              Text('Choose how you want to pay for this booking.', style: TextStyle(color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 32),
              
              if (_selectedSeats.length > 1) ...[
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSplitPaymentDialog(context);
                  },
                  icon: Icon(Icons.group_rounded, color: colorScheme.primary),
                  label: Text('Group Split-Payment', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: colorScheme.primary, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _processBooking(isSplitPayment: false);
                },
                icon: const Icon(Icons.payment_rounded),
                label: const Text('Pay Full Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSplitPaymentDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final int seatCount = _selectedSeats.length;
    final List<TextEditingController> controllers = List.generate(
      seatCount, 
      (i) => TextEditingController(
        text: (i == 0) ? (FirebaseAuth.instance.currentUser?.email ?? '') : ''
      )
    );
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: Row(
            children: [
              Icon(Icons.group_add_rounded, color: colorScheme.primary),
              const SizedBox(width: 12),
              const Text('Split Payment', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
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
                    style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(seatCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: controllers[index],
                        style: TextStyle(color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          labelText: index == 0 ? "Your Email (Initiator)" : "Friend ${index}'s Email",
                          hintText: "example@email.com",
                          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: Icon(index == 0 ? Icons.person_rounded : Icons.email_outlined, color: colorScheme.primary),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
            ),
            FilledButton(
              onPressed: () {
                final emails = controllers.map((c) => c.text.trim()).toList();
                for (var email in emails) {
                  if (email.isEmpty || !email.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter valid emails for ALL seats. (Invalid: $email)'))
                    );
                    return;
                  }
                }
                Navigator.pop(context);
                _processBooking(isSplitPayment: true, splitEmails: emails);
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Send Invites', style: TextStyle(fontWeight: FontWeight.bold)),
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
  final Color color;
  ScreenPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);
    
    // Draw a subtle shadow under the curve
    final shadowPaint = Paint()
      ..color = color.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
