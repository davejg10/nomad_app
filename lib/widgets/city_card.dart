import 'package:flutter/material.dart';

import '../constants.dart';
import '../domain/city.dart';

class CityCard extends StatelessWidget {
  const CityCard({super.key, required this.city, required this.trailingIcon, required this.cardOnTap, required this.arrowIconOnTap});

  final City city;
  final IconData trailingIcon;
  final void Function(City selectedCity) cardOnTap;
  final void Function(City selectedCity) arrowIconOnTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        cardOnTap(city);
      },
      child: Card(
        elevation: kCardElevation,
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: kCardPadding,
          child: Row(
            children: [
              Icon(city.getIcon),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(city.getName, style: TextStyle(fontWeight: kFontWeight, fontSize: 18),),
                    Text(city.getDescription, overflow: TextOverflow.ellipsis,)
                  ],
                ),
              ),
              IconButton(
                icon: Icon(trailingIcon),
                onPressed: () {
                  arrowIconOnTap(city);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}