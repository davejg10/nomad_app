import 'package:flutter/material.dart';

import '../domain/city.dart';

class CityDetailsScreen extends StatelessWidget {
  const CityDetailsScreen({super.key, required this.selectedCity});

  final City selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(selectedCity.getName),
      )
    );
  }
}
