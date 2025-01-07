import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/widgets/city_card.dart';

import '../../../domain/city.dart';

class ItinerarySliverView extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<City> routeList = ref.watch(routeListProvider);
    return SliverList.separated(
        itemCount: routeList.length,
        itemBuilder: (context, index) {
          City city = routeList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CityCard(
                key: Key('cityCard${city.getName}'),
                city: city,
                trailingIcon: Symbols.close,
                trailingIconOnTap: (City selectedCity) {
                  ref.read(routeListProvider.notifier).removeFromItinerary(selectedCity);
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