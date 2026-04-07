import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import '../core/app_colors.dart';
import '../models/core_models.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../core/app_colors.dart';
import '../models/core_models.dart';

class TicketDetailsScreen extends StatefulWidget {
  final Ticket ticket;
  const TicketDetailsScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    final difference = now.difference(widget.ticket.date).inSeconds;
    _remainingSeconds = (15 * 60) - difference;
    if (_remainingSeconds < 0) _remainingSeconds = 0;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFFA020F0);
    const Color headerPurple = Color(0xFF5B0A95);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [headerPurple, primaryPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ticket Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(widget.ticket.id.substring(0, 15).toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (widget.ticket.isSplitPayment)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Split Payment Pending',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Waiting for ${widget.ticket.splitWithEmails.join(", ")} to pay their share of LKR ${(widget.ticket.totalAmount / (widget.ticket.splitWithEmails.length + 1)).toInt()}.',
                            style: TextStyle(color: Colors.orange.shade800, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // QR Code Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryPurple.withOpacity(0.5), width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: QrImageView(
                          data: widget.ticket.id,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                      if (widget.ticket.isSplitPayment)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                color: Colors.black.withOpacity(0.1),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.lock_person_rounded, color: Colors.white, size: 48),
                                    const SizedBox(height: 12),
                                    const Text('LOCKED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _formatTime(_remainingSeconds),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Scan at entrance', style: TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text('Booking Ref: ${widget.ticket.id.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black45)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Movie Details Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.ticket.movie.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 24),
                  _buildDetailRow(Icons.location_on_outlined, 'Cinema', '${widget.ticket.cinema.name} - Hall 1'),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.calendar_today_outlined, 'Date & Time', 'Today, ${widget.ticket.showtime.time}'),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.movie_filter_outlined, 'Format & Seats', ''),
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0, top: 4),
                    child: Row(
                      children: [
                        _buildChip(widget.ticket.showtime.format, const Color(0xFFF3F4F6)),
                        const SizedBox(width: 8),
                        ...widget.ticket.seatNumbers.map((s) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _buildChip(s, const Color(0xFFF3F4F6)),
                        )),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
                      Text('LKR ${widget.ticket.totalAmount.toInt()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryPurple)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.black26),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.black38, fontWeight: FontWeight.w500)),
              if (value.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
