import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/screens/city_details/city_details_screen.dart';

import '../constants.dart';
import '../domain/city.dart';

class CityCard extends ConsumerWidget {
  const CityCard({
    super.key,
    required this.city,
    required this.trailingIconButton,
  });

  final City city;
  final IconButton trailingIconButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CityDetailsScreen(selectedCity: city),
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
              trailingIconButton,
            ],
          ),
        ),
      ),
    );
  }
}