import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/app_colors.dart';
import '../models/core_models.dart';
import '../services/database_service.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  bool _showActive = true;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    const Color primaryPurple = Color(0xFFA020F0);
    const Color headerPurple = Color(0xFF5B0A95);

    if (user == null) {
<<<<<<< HEAD:lib/views/tickets_screen.dart
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('My Tickets'),
        ),
        body: Center(
          child: Text('Please log in to view your tickets.', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onBackground)),
        ),
=======
      return const Scaffold(
        backgroundColor: Color(0xFFF9FAFB),
        body: Center(child: Text('Please log in to view your tickets.')),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
<<<<<<< HEAD:lib/views/tickets_screen.dart
      backgroundColor: colorScheme.background,
=======
      backgroundColor: const Color(0xFFF9FAFB),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
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
<<<<<<< HEAD:lib/views/tickets_screen.dart
          children: [
            const Text('My Tickets', style: TextStyle(fontSize: 18)),
            Text('Your booking history', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: colorScheme.onSurfaceVariant)),
          ],
        ),
        backgroundColor: colorScheme.surface,
=======
          children: const [
            Text('My Tickets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Your booking history', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
      ),
      body: StreamBuilder<List<Ticket>>(
        stream: DatabaseService().getUserTicketsStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final tickets = snapshot.data ?? [];
          final now = DateTime.now().subtract(const Duration(hours: 3));
          final activeTickets = tickets.where((t) => t.date.isAfter(now)).toList();
          final pastTickets = tickets.where((t) => t.date.isBefore(now)).toList();
          final displayTickets = _showActive ? activeTickets : pastTickets;

          return Column(
            children: [
<<<<<<< HEAD:lib/views/tickets_screen.dart
              Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showActive = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _showActive ? colorScheme.secondaryContainer : Colors.transparent, 
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text('Active (${activeTickets.length})', 
                              style: TextStyle(
                                color: _showActive ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant, 
                                fontWeight: FontWeight.bold,
=======
              // Custom Toggle Toggle
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showActive = true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _showActive ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _showActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
                            ),
                            child: Center(
                              child: Text(
                                'Active (${activeTickets.length})',
                                style: TextStyle(
                                  fontWeight: _showActive ? FontWeight.bold : FontWeight.w500,
                                  color: _showActive ? Colors.black87 : Colors.black45,
                                ),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
                              ),
                            ),
                          ),
                        ),
                      ),
<<<<<<< HEAD:lib/views/tickets_screen.dart
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showActive = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_showActive ? colorScheme.secondaryContainer : Colors.transparent, 
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text('Past (${pastTickets.length})', 
                              style: TextStyle(
                                color: !_showActive ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant, 
                                fontWeight: FontWeight.bold,
=======
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showActive = false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !_showActive ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: !_showActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
                            ),
                            child: Center(
                              child: Text(
                                'Past (${pastTickets.length})',
                                style: TextStyle(
                                  fontWeight: !_showActive ? FontWeight.bold : FontWeight.w500,
                                  color: !_showActive ? Colors.black87 : Colors.black45,
                                ),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: displayTickets.isEmpty
                  ? Center(
                      child: Text(
                        _showActive ? 'No active tickets.' : 'No past tickets.',
                        style: const TextStyle(color: Colors.black45),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: displayTickets.length,
                      itemBuilder: (context, index) {
                        return _buildTicketCard(context, displayTickets[index]);
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Ticket ticket) {
<<<<<<< HEAD:lib/views/tickets_screen.dart
    final colorScheme = Theme.of(context).colorScheme;
=======
    const Color primaryPurple = Color(0xFFA020F0);
    const Color logoYellow = Color(0xFFFFC107);

>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
    return GestureDetector(
      onTap: () => context.push('/ticket-details', extra: ticket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Top Section (Purple)
            Container(
<<<<<<< HEAD:lib/views/tickets_screen.dart
              padding: const EdgeInsets.all(16),
              color: colorScheme.primaryContainer,
=======
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B25F2), Color(0xFFA020F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD:lib/views/tickets_screen.dart
                        Text(ticket.movie.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer)),
                        const SizedBox(height: 4),
                        Text('${ticket.cinema.name} - Hall 1', style: TextStyle(color: colorScheme.onPrimaryContainer.withOpacity(0.8), fontSize: 13)),
=======
                        Text(
                          ticket.movie.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ticket.cinema.name} - Hall 1',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
<<<<<<< HEAD:lib/views/tickets_screen.dart
                      color: ticket.status == 'Pending Split Payment' ? colorScheme.errorContainer : colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(ticket.status == 'Pending Split Payment' ? Icons.hourglass_top : Icons.qr_code, size: 14, color: ticket.status == 'Pending Split Payment' ? colorScheme.onErrorContainer : colorScheme.onTertiaryContainer),
                        const SizedBox(width: 4),
                        Text(ticket.status == 'Pending Split Payment' ? 'Pending' : 'Ready', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ticket.status == 'Pending Split Payment' ? colorScheme.onErrorContainer : colorScheme.onTertiaryContainer)),
=======
                      color: logoYellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.qr_code_2_rounded, size: 14, color: Colors.black),
                        SizedBox(width: 4),
                        Text('Ready', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
                      ],
                    ),
                  ),
                ],
              ),
            ),
<<<<<<< HEAD:lib/views/tickets_screen.dart
            Container(
              color: colorScheme.surface,
              padding: const EdgeInsets.all(16.0),
=======

            // Middle Section
            Padding(
              padding: const EdgeInsets.all(20.0),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
<<<<<<< HEAD:lib/views/tickets_screen.dart
                      Row(
                        children: [
                           Icon(Icons.calendar_today, size: 14, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            '${ticket.date.year}-${ticket.date.month.toString().padLeft(2, '0')}-${ticket.date.day.toString().padLeft(2, '0')}', 
                            style: TextStyle(color: colorScheme.onSurfaceVariant)
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(ticket.showtime.time, style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Colors.black12),
=======
                      _buildTicketInfoItem(Icons.calendar_today_outlined, 'Today'),
                      _buildTicketInfoItem(Icons.access_time, ticket.showtime.time),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Divider(height: 1, color: Color(0xFFF3F4F6)),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
<<<<<<< HEAD:lib/views/tickets_screen.dart
                          Text('Seats', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 4),
                          Row(
                            children: ticket.seatNumbers.map((seat) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(4)),
                                child: Text(seat, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: colorScheme.primary)),
                              ),
=======
                          const Text('Seats', style: TextStyle(fontSize: 12, color: Colors.black45)),
                          const SizedBox(height: 8),
                          Row(
                            children: ticket.seatNumbers.map((s) => Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6)),
                              child: Text(s, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
                            )).toList(),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
<<<<<<< HEAD:lib/views/tickets_screen.dart
                          Text('Total', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 4),
                          Text('LKR ${ticket.totalAmount.toInt()}', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)),
=======
                          const Text('Total', style: TextStyle(fontSize: 12, color: Colors.black45)),
                          const SizedBox(height: 8),
                          Text(
                            'LKR ${ticket.totalAmount.toInt()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryPurple),
                          ),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
<<<<<<< HEAD:lib/views/tickets_screen.dart
                      Text('Ref: ${ticket.id.substring(0, 15)}...', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(4)),
                        child: Text(ticket.showtime.format, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant)),
=======
                      Text(
                        'Ref: ${ticket.id.substring(0, 10).toUpperCase()}',
                        style: const TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          ticket.showtime.format,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                        ),
>>>>>>> pr/5:CineBook/lib/views/tickets_screen.dart
                      ),
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

  Widget _buildTicketInfoItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black45),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }
}
