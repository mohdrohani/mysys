import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FreeMapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final String? markerLabel;
  final Function(LatLng)? onTap;

  const FreeMapWidget({
    super.key,
    required double latitude,
    required double longitude,
    double? zoom,
    this.markerLabel,
    this.onTap,
  })  : latitude = latitude,
        longitude = longitude,
        zoom = zoom ?? 16.0;

  @override
  Widget build(BuildContext context) {
    // Check if coordinates are valid (not 0,0 and not NaN/Infinity)
    final hasValidCoordinates = latitude.isFinite && 
                                longitude.isFinite && 
                                (latitude != 0.0 || longitude != 0.0);
    
    // Use the provided coordinates if valid, otherwise use default
    final mapCenter = hasValidCoordinates
        ? LatLng(latitude, longitude)
        : LatLng(18.2503767, 42.7637642); // Default: center of world    
    // Ensure zoom is valid
    final double validZoom = zoom.isFinite && zoom >= 2 && zoom <= 18 ? zoom : 4;

    return SizedBox(
      height: 300, // Fixed height for the map
      child: FlutterMap(
        options: MapOptions(
          initialCenter: mapCenter,
          initialZoom: validZoom,
          minZoom: 2,
          maxZoom: 18,
          onTap: (tapPosition, point) {
            if (onTap != null) {
              onTap!(point);
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.mysys',
            subdomains: const ['a', 'b', 'c'],
          ),
          // Only show marker if we have valid real coordinates (not defaults)
          if (hasValidCoordinates)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}