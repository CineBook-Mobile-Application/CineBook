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
    final colorScheme = Theme.of(context).colorScheme;
    const Color logoYellow = Color(0xFFFFC107);
    const Color headerPurple = Color(0xFF5B0A95);

    if (user == null) {
      return Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          title: const Text('My Tickets'),
        ),
        body: Center(
          child: Text('Please log in to view your tickets.', style: TextStyle(fontSize: 16, color: colorScheme.onBackground)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [headerPurple, colorScheme.primary],
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
          children: const [
            Text('My Tickets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Your booking history', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
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
              // Custom Toggle
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showActive = true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _showActive ? colorScheme.surface : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _showActive ? [BoxShadow(color: colorScheme.shadow.withOpacity(0.05), blurRadius: 4)] : [],
                            ),
                            child: Center(
                              child: Text(
                                'Active (${activeTickets.length})',
                                style: TextStyle(
                                  fontWeight: _showActive ? FontWeight.bold : FontWeight.w500,
                                  color: _showActive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showActive = false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !_showActive ? colorScheme.surface : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: !_showActive ? [BoxShadow(color: colorScheme.shadow.withOpacity(0.05), blurRadius: 4)] : [],
                            ),
                            child: Center(
                              child: Text(
                                'Past (${pastTickets.length})',
                                style: TextStyle(
                                  fontWeight: !_showActive ? FontWeight.bold : FontWeight.w500,
                                  color: !_showActive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                                ),
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
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
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
    final colorScheme = Theme.of(context).colorScheme;
    const Color logoYellow = Color(0xFFFFC107);
    
    return GestureDetector(
      onTap: () => context.push('/ticket-details', extra: ticket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: colorScheme.shadow.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Top Section (Purple Gradient)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary.withOpacity(0.8), colorScheme.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.movie.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ticket.cinema.name} - Hall 1',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: ticket.status == 'Pending Split Payment' ? Colors.orangeAccent : logoYellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          ticket.status == 'Pending Split Payment' ? Icons.hourglass_top : Icons.qr_code_2_rounded, 
                          size: 14, 
                          color: Colors.black
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ticket.status == 'Pending Split Payment' ? 'Pending' : 'Ready', 
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Middle Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTicketInfoItem(context, Icons.calendar_today_outlined, 
                        '${ticket.date.year}-${ticket.date.month.toString().padLeft(2, '0')}-${ticket.date.day.toString().padLeft(2, '0')}'),
                      _buildTicketInfoItem(context, Icons.access_time, ticket.showtime.time),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Divider(height: 1, color: colorScheme.outlineVariant),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Seats', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 8),
                          Row(
                            children: ticket.seatNumbers.map((s) => Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(6)),
                              child: Text(s, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colorScheme.onSurface)),
                            )).toList(),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 8),
                          Text(
                            'LKR ${ticket.totalAmount.toInt()}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ref: ${ticket.id.substring(0, 10).toUpperCase()}',
                        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant.withOpacity(0.6), fontWeight: FontWeight.w500),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          ticket.showtime.format,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
                        ),
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

  Widget _buildTicketInfoItem(BuildContext context, IconData icon, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
      ],
    );
  }
}
