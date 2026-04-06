import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/core_models.dart';
import '../services/database_service.dart';
import '../core/app_colors.dart';

class CinemaMapScreen extends StatefulWidget {
  final Cinema? targetCinema;
  const CinemaMapScreen({Key? key, this.targetCinema}) : super(key: key);

  @override
  State<CinemaMapScreen> createState() => _CinemaMapScreenState();
}

class _CinemaMapScreenState extends State<CinemaMapScreen> {
  final DatabaseService _db = DatabaseService();
  late GoogleMapController mapController;
  
  // Center roughly around Colombo, or the target cinema if provided!
  late LatLng _colomboCenter;
  late Future<List<Cinema>> _cinemasFuture;

  @override
  void initState() {
    super.initState();
    if (widget.targetCinema != null) {
      _colomboCenter = LatLng(widget.targetCinema!.latitude, widget.targetCinema!.longitude);
    } else {
      _colomboCenter = const LatLng(6.9271, 79.8612);
    }
    _cinemasFuture = _db.getCinemas();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Cinemas'),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<List<Cinema>>(
        future: _cinemasFuture,
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
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        },
      ),
    );
  }
}
