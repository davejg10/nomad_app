import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/screens/select_city/widgets/route_select_dialogue.dart';

import '../../../widgets/city_card.dart';
import '../providers/providers.dart';
import 'city_card_shimmer.dart';

class CityListView extends ConsumerWidget {
  const CityListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastCitySelected = ref.read(lastCitySelectedProvider);
    final queriedCityListProviderState = ref.watch(availableCityQueriedListProvider);

    return queriedCityListProviderState.when(
        data: (cityList) {
          return ListView.builder(
              itemCount: cityList.length,
              itemBuilder: (context, index) {
                Neo4jCity city = cityList.elementAt(index);
                Set<Neo4jRoute> routes = lastCitySelected!.fetchRoutesForGivenCity(city.getId);
                return CityCard(
                  key: Key('cityCard${city.getName}'),
                  lastCitySelected: ref.read(lastCitySelectedProvider)!,
                  selectedCity: city,
                  routesToSelectedCity: routes,
                  trailingIconButton: IconButton(
                    icon: const Icon(Symbols.add),
                    onPressed: () {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AddToItineraryDialogue(selectedCity: city);
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