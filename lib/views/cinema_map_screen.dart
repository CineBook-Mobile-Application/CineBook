import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../models/core_models.dart';
import '../services/database_service.dart';

class CinemaMapScreen extends StatefulWidget {
  final Cinema? targetCinema;
  const CinemaMapScreen({Key? key, this.targetCinema}) : super(key: key);

  @override
  State<CinemaMapScreen> createState() => _CinemaMapScreenState();
}

class _CinemaMapScreenState extends State<CinemaMapScreen> {
  final DatabaseService _db = DatabaseService();
  late GoogleMapController _mapController;
  Cinema? _selectedCinema;
  late LatLng _colomboCenter;

  @override
  void initState() {
    super.initState();
    if (widget.targetCinema != null) {
      _colomboCenter = LatLng(widget.targetCinema!.latitude, widget.targetCinema!.longitude);
      _selectedCinema = widget.targetCinema;
    } else {
      _colomboCenter = const LatLng(6.9271, 79.8612);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _setMapStyle();
  }

  void _setMapStyle() async {
    String style = '''
    [
      { "elementType": "geometry", "stylers": [ { "color": "#f5f5f5" } ] },
      { "elementType": "labels.icon", "stylers": [ { "visibility": "off" } ] },
      { "elementType": "labels.text.fill", "stylers": [ { "color": "#616161" } ] },
      { "elementType": "labels.text.stroke", "stylers": [ { "color": "#f5f5f5" } ] },
      { "featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [ { "color": "#bdbdbd" } ] },
      { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#eeeeee" } ] },
      { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] },
      { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#ffffff" } ] },
      { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#c9c9c9" } ] }
    ]
    ''';
    _mapController.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const Color headerPurple = Color(0xFF5B0A95);

    return Scaffold(
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
        title: const Text('Nearby Cinemas', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<Cinema>>(
            stream: _db.getCinemasStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

              final cinemas = snapshot.data ?? [];
              
              final Set<Marker> markers = cinemas.map((cinema) {
                final isSelected = _selectedCinema?.id == cinema.id;
                return Marker(
                  markerId: MarkerId(cinema.id),
                  position: LatLng(cinema.latitude, cinema.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    isSelected ? BitmapDescriptor.hueRed : BitmapDescriptor.hueViolet
                  ),
                  onTap: () {
                    setState(() {
                      _selectedCinema = cinema;
                    });
                    _mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(cinema.latitude, cinema.longitude), 15));
                  },
                );
              }).toSet();

              return GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _colomboCenter,
                  zoom: widget.targetCinema != null ? 15.0 : 12.0,
                ),
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onTap: (_) => setState(() => _selectedCinema = null),
              );
            },
          ),
          if (_selectedCinema != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              child: _buildCinemaDetailCard(context, _selectedCinema!),
            ),
        ],
      ),
    );
  }

  Widget _buildCinemaDetailCard(BuildContext context, Cinema cinema) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: colorScheme.shadow.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.movie_filter_rounded, color: colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cinema.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                    Text(cinema.location, style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                onPressed: () => setState(() => _selectedCinema = null),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildInfoChip(context, Icons.location_on, '${cinema.distanceKm} km away'),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  context.push('/cinemas/1'); 
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
