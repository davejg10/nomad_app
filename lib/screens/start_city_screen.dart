import 'package:flutter/material.dart';
import 'package:nomad/global_screen.dart';
import 'package:nomad/screens/city_details_screen.dart';

import '../data/destination_respository.dart';
import '../domain/city.dart';
import '../domain/country.dart';
import '../widgets/city_list_view.dart';
import '../widgets/page_title.dart';
import 'next_city_screen.dart';

class StartCityScreen extends StatelessWidget {
  StartCityScreen({super.key, required this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    return GlobalScreen(
      child: Column(
        children: [
          PageTitle(titleText: country.getName),
          Expanded(
            child: CityListView(
              cityList: scopedCities,
              cardOnTap: (City selectedCity) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NextCityScreen(routeList: [selectedCity]),
                  ),
                );
              },
              arrowIconOnTap: (City selectedCity) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CityDetailsScreen(selectedCity: selectedCity),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}