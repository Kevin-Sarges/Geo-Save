import 'package:flutter/material.dart';

class TemplateModalWidget extends StatelessWidget {
  const TemplateModalWidget({
    super.key,
    required this.lon,
    required this.lat,
  });

  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text(
              "Latitude",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(lat.toString())
          ],
        ),
        Column(
          children: [
            const Text(
              "Latitude",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(lon.toString())
          ],
        ),
      ],
    );
  }
}
