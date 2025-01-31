import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/screens/select_city/providers/all_cities_provider.dart';
import 'package:nomad/screens/select_city/providers/queried_city_list_provider.dart';

import '../../../domain/city.dart';
import '../../../widgets/city_card.dart';
import 'city_card_shimmer.dart';

class CityListView extends ConsumerWidget {
  const CityListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queriedCityListProviderState = ref.watch(queriedCityListProvider);

    return queriedCityListProviderState.when(
        data: (cityList) {
          return ListView.builder(
              itemCount: cityList.length,
              itemBuilder: (context, index) {
                City city = cityList.elementAt(index);
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
        },
        error: (error, trace) {
          return Container();
        },
        loading: () {
          return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return CityCardShimmer();
              }
          );
        }
    );
  }
}