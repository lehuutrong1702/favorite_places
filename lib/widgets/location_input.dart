import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/services/api_service.dart';
import 'package:favorite_places/widgets/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationInput extends ConsumerStatefulWidget {
  const LocationInput({super.key, required this.onLocationInput});

  final void Function(LocationPlace location) onLocationInput;

  @override
  ConsumerState<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends ConsumerState<LocationInput> {
  LocationPlace? _pickedLocation;
  var _isGettingLocation = false;
  String? _address;

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    final apiService = ref.watch(apiServiceProvider);

    _address = await apiService.loadLocation(
        locationData.latitude.toString(), locationData.longitude.toString());

    setState(() {
      _pickedLocation = LocationPlace(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          address: _address!);

      _isGettingLocation = false;
    });

    widget.onLocationInput(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No chosen location",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (_address != null) {
      previewContent = DynamicMap(latitude: _pickedLocation!.latitude, longitude: _pickedLocation!.longitude);
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Get current location"),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text("Select on map"),
            )
          ],
        ),
      ],
    );
  }
}
