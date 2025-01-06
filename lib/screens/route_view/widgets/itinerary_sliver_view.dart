import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/screens/city_details/city_details_screen.dart';
import 'package:nomad/widgets/city_card.dart';

import '../../../domain/city.dart';

class ItinerarySliverView extends StatefulWidget {
  const ItinerarySliverView({super.key, required this.routeList});

  final List<City> routeList;

  @override
  State<ItinerarySliverView> createState() => _ItinerarySliverViewState();
}

class _ItinerarySliverViewState extends State<ItinerarySliverView> {

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
        itemCount: widget.routeList.length,
        itemBuilder: (context, index) {
          City city = widget.routeList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CityCard(
                key: Key('cityCard${city.getName}'),
                city: city,
                trailingIcon: Symbols.close,
                cardOnTap: (City selectedCity) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CityDetailsScreen(selectedCity: selectedCity),
                    ),
                  );
                },
                arrowIconOnTap: (City selectedCity) {
                  setState(() {
                    widget.routeList.remove(selectedCity);
                  });
                }
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Symbols.south,
                weight: 150,
                size: 80,
                opticalSize: 6.0,
                fill: 1,
              ),
              Positioned(right: 110, child: Text('WEIGHT(1)'))
            ],
          );
        }
    );
  }
}