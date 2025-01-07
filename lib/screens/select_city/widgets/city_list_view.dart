import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/screens/select_city/providers/queried_city_list_provider.dart';

import '../../../domain/city.dart';
import '../../../widgets/city_card.dart';

class CityListView extends ConsumerWidget {
  const CityListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<City> queriedCityList = ref.watch(queriedCityListProvider);
    return ListView.builder(
      itemCount: queriedCityList.length,
      itemBuilder: (context, index) {
        City city = queriedCityList[index];
        return CityCard(
          key: Key('cityCard${city.getName}'),
          city: city,
          trailingIcon: Symbols.add,
          trailingIconOnTap: (City selectedCity) {
            ref.read(routeListProvider.notifier).addToItinerary(city);
          },
        );
      }
    );
  }
}