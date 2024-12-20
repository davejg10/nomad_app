import 'package:flutter/material.dart';

import '../constants.dart';
import '../domain/country.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({super.key, required this.country, required this.cardOnTap});

  final Country country;
  final void Function(Country selectedCountry) cardOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            cardOnTap(country);
          },
          child: Card(
            margin: EdgeInsets.all(0.0),
            shape: ContinuousRectangleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
        Divider(
          color: Colors.black,
          height: 0,
        )
      ],
    );
  }
}
