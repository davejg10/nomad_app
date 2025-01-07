import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/selected_country_provider.dart';
import 'package:nomad/screens/select_city/select_city_screen.dart';

import '../../../constants.dart';
import '../../../domain/country.dart';

class CountryCard extends ConsumerWidget {
  const CountryCard({
    super.key,
    required this.country
  });

  final Country country;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(selectedCountryProvider.notifier).setCountry(country);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    SelectCityScreen(),
              ),
            );
          },
          child: Card(
            elevation: kCardElevation,
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: kCardPadding,
              child: Row(
                children: [
                  Icon(country.getIcon),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(country.getName, style: const TextStyle(fontWeight: kFontWeight, fontSize: 18),),
                        Text(country.getDescription, overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
