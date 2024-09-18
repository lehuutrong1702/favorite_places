import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DynamicMap extends StatelessWidget {
  const DynamicMap({super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter:
            LatLng(latitude, longitude), // Center the map over London
        initialZoom: 9.2,
        keepAlive: true,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          maxNativeZoom: 19,
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(
                  latitude, longitude), // Tọa độ của Thành phố Long Xuyên
              child: const Icon(Icons.location_on, color: Colors.red,),
            ),
          ],
        ),
      ],
    );
  }
}
