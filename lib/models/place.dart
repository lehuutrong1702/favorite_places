import 'dart:io';

import 'package:uuid/uuid.dart';

final uuid = Uuid();

class LocationPlace {
  LocationPlace(
      {required this.latitude, required this.longitude, required this.address});

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({required this.title, required this.image, this.location, String? id}) : id = id ?? uuid.v4();

  LocationPlace? location;

  String id;
  String title;
  File image;
}
