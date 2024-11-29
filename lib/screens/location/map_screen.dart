import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String time;
  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Location Map',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              time,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
            center: LatLng(latitude, longitude),
            zoom: 14.0,
            maxZoom: 19,
            minZoom: 3),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            maxZoom: 19,
            minZoom: 3,
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(latitude, longitude),
                builder: (ctx) => const Icon(
                  Icons.location_on,
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
