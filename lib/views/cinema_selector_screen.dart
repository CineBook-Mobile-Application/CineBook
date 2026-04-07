import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_colors.dart';
import '../models/core_models.dart';
import 'cinema_map_screen.dart';
import '../services/database_service.dart';

class CinemaSelectorScreen extends StatelessWidget {
  final String movieId;
  const CinemaSelectorScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFFA020F0);
    const Color headerPurple = Color(0xFF5B0A95);
    final colorScheme = Theme.of(context).colorScheme;

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Select Cinema', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Choose your preferred location', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Date Picker
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [headerPurple, colorScheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDateChip(context, 'Today', true),
                _buildDateChip(context, 'Tomorrow', false),
                _buildDateChip(context, 'Mar 19', false),
              ],
            ),
          ),
          
          // Location Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Colombo, Sri Lanka',
                    style: TextStyle(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/cinema-map'),
                  icon: Icon(Icons.near_me, size: 16, color: colorScheme.primary),
                  label: Text('Near me', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Cinema>>(
              stream: DatabaseService().getCinemasStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final liveCinemas = snapshot.data ?? [];
                if (liveCinemas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No cinemas found.'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.go('/home'),
                          child: const Text('Go Home to Seed Data'),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  itemCount: liveCinemas.length,
                  itemBuilder: (context, index) {
                    return _buildCinemaCard(context, liveCinemas[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(BuildContext context, String label, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? Colors.white : Colors.white24),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, size: 16, color: isSelected ? colorScheme.primary : Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? colorScheme.primary : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaCard(BuildContext context, Cinema cinema) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colorScheme.shadow.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cinema.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                      const SizedBox(height: 6),
                      Text(cinema.location, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/cinema-map', extra: cinema),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text('${cinema.distanceKm} km', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Showtimes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 16,
              children: cinema.showtimes.map((s) => _buildShowtimeCard(context, cinema, s)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowtimeCard(BuildContext context, Cinema cinema, Showtime showtime) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        context.push('/seat-selection', extra: {
          'movieId': movieId,
          'cinema': cinema,
          'showtime': showtime,
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 92) / 2, // 2 items per row
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: colorScheme.onSurface),
                    children: [
                      TextSpan(text: showtime.time.split(' ')[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const TextSpan(text: ' '),
                      TextSpan(text: showtime.time.split(' ')[1], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    showtime.format,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.onTertiaryContainer),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('LKR ${showtime.price.toInt()}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${showtime.availableSeats} seats',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: showtime.isFillingFast ? Colors.red : Colors.green,
                  ),
                ),
                if (showtime.isFillingFast)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Filling Fast', style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
