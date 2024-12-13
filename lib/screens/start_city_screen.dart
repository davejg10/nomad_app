import 'package:flutter/material.dart';
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
  final DestinationRepository repo = DestinationRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageTitle(titleText: country.getName),
            Expanded(
              child: CityListView(
                cityList: repo.getCitiesGivenCountry(country.getId),
                cardOnTap: (City selectedCity) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NextCityScreen(startCity: selectedCity),
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
      ),
    );
  }
}