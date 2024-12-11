import 'package:flutter/material.dart';

import '../domain/city.dart';

class NextCityScreen extends StatefulWidget {
  NextCityScreen({super.key, required this.startCity});

  final City startCity;

  @override
  State<NextCityScreen> createState() => _NextCityScreenState();
}

class _NextCityScreenState extends State<NextCityScreen> {

  List<City> routeList = [];

  @override
  void initState() {
    super.initState();
    routeList.add(widget.startCity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Text(routeList.first.toString()),
        )
    );
  }
}

