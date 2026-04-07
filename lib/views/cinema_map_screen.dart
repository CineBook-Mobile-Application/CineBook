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
    const Color primaryPurple = Color(0xFFA020F0);

    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD:lib/views/cinema_map_screen.dart
        title: const Text('Nearby Cinemas'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: StreamBuilder<List<Cinema>>(
        stream: _db.getCinemasStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading map data: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cinemas = snapshot.data ?? [];
          
          // Predefined distinct colors for mapping
          final List<double> markerHues = [
            BitmapDescriptor.hueViolet,
            BitmapDescriptor.hueRed,
            BitmapDescriptor.hueBlue,
            BitmapDescriptor.hueGreen,
            BitmapDescriptor.hueOrange,
            BitmapDescriptor.hueRose,
            BitmapDescriptor.hueCyan,
          ];

          // Generate Map Markers
          int idx = 0;
          final Set<Marker> markers = cinemas.map((cinema) {
            final hue = markerHues[idx % markerHues.length];
            idx++;
            return Marker(
              markerId: MarkerId(cinema.id),
              position: LatLng(cinema.latitude, cinema.longitude),
              infoWindow: InfoWindow(
                title: cinema.name,
                snippet: '${cinema.location} • ${cinema.distanceKm}km away',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(hue),
            );
          }).toSet();

          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _colomboCenter,
              zoom: widget.targetCinema != null ? 15.0 : 12.0, // Zoom closer if target is provided
=======
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5B0A95), Color(0xFFA020F0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
>>>>>>> pr/5:CineBook/lib/views/cinema_map_screen.dart
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
    const Color primaryPurple = Color(0xFFA020F0);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 10))
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
                decoration: BoxDecoration(color: primaryPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.movie_filter_rounded, color: primaryPurple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cinema.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text(cinema.location, style: const TextStyle(fontSize: 13, color: Colors.black45)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black26),
                onPressed: () => setState(() => _selectedCinema = null),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildInfoChip(Icons.location_on, '${cinema.distanceKm} km away'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.push('/cinemas/1'); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 0,
                ),
                child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
        ],
      ),
    );
  }
}
