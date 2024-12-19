import 'package:flutter/material.dart';

import '../domain/city.dart';
import 'city_card.dart';

class CityListView extends StatelessWidget {
  const CityListView({super.key, required this.cityList, required this.cardOnTap, required this.arrowIconOnTap});

  final List<City> cityList;
  final void Function(City selectedCity) cardOnTap;
  final void Function(City selectedCity) arrowIconOnTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: cityList.length,
        itemBuilder: (context, index) {
          City city = cityList[index];
          return CityCard(
            key: Key('cityCard${city.getName}'),
              city: city,
              cardOnTap: cardOnTap,
              arrowIconOnTap: arrowIconOnTap
          );
        }
    );
  }
}