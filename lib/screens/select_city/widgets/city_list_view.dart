import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/screens/select_city/widgets/route_select_dialogue.dart';

import '../../../domain/city.dart';
import '../../../widgets/city_card.dart';
import '../providers/providers.dart';
import 'city_card_shimmer.dart';

class CityListView extends ConsumerWidget {
  const CityListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSelectedCity = ref.read(currentCitySelectedProvider);
    final queriedCityListProviderState = ref.watch(availableCityQueriedListProvider);

    return queriedCityListProviderState.when(
        data: (cityList) {
          return ListView.builder(
              itemCount: cityList.length,
              itemBuilder: (context, index) {
                City city = cityList.elementAt(index);
                Set<RouteEntity> routes = currentSelectedCity!.fetchRoutesForGivenCity(city.getId);
                return CityCard(
                  key: Key('cityCard${city.getName}'),
                  city: city,
                  trailingIconButton: IconButton(
                    icon: const Icon(Symbols.add),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return RouteSelectDialogue(routes: routes);
                        }
                      );
                    },
                  ),
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