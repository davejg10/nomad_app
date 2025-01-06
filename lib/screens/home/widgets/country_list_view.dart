import 'package:flutter/material.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/screens/home/widgets/country_card.dart';

class CountryListView extends StatelessWidget {
  const CountryListView({
    super.key,
    required this.countryList,
    required this.cardOnTap,
  });

  final List<Country> countryList;
  final void Function(Country selectedCountry) cardOnTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: countryList.length,
        itemBuilder: (context, index) {
          Country country = countryList[index];
          return CountryCard(
            key: Key('countryCard${country.getName}'),
            country: country,
            cardOnTap: cardOnTap,
          );
        }
    );
  }
}
