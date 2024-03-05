// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:geosave/app/common/colors/colors_app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullMapLocalScreen extends StatelessWidget {
  FullMapLocalScreen({
    Key? key,
    required this.lat,
    required this.lon,
  }) : super(key: key);

  final double lat;
  final double lon;
  late GoogleMapController controller;

  void _onCreatedMap(GoogleMapController controller) {
    controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsApp.white100,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              lat,
              lon,
            ),
            zoom: 20,
          ),
          onMapCreated: _onCreatedMap,
          markers: {
            Marker(
              markerId: const MarkerId('maker 01'),
              position: LatLng(
                lat,
                lon,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ),
          },
        ),
      ),
    );
  }
}
