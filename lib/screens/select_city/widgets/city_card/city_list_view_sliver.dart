import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_queried_list_provider.dart';
import 'package:nomad/widgets/city_card/city_card.dart';
import 'package:nomad/widgets/generic/add_remove_dialogue.dart';

import 'city_card_shimmer.dart';

class CityListView extends ConsumerWidget {
  const CityListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isOriginCity = ref.read(itineraryListProvider).isEmpty;
    final queriedCityListProviderState = ref.watch(availableCityQueriedListProvider);

    return queriedCityListProviderState.when(
        data: (cityList) {
          return SliverList.builder(
              itemCount: cityList.length,
              itemBuilder: (context, index) {
                Neo4jCity city = cityList.elementAt(index);
                Neo4jCity lastCitySelected = isOriginCity ? city : ref.read(itineraryListProvider).last;
                return CityCard(
                  key: Key('cityCard${city.getName}'),
                  lastCitySelected: lastCitySelected,
                  selectedCity: city,
                  trailingButton: IconButton(
                    icon: const Icon(Symbols.add),
                    onPressed: () async {
                      final bool? confirmed = await showAddRemoveDialogue(context: context, contextName: city.getName, action: ConfirmationAction.add, onConfirm: () {});
                      if (confirmed == true) {
                        ref.read(widgetVisibilityProvider(WidgetVisibilityProviderIdentifier.SELECT_CITY_LAST_CITY_TILE).notifier).close();
                        ref.read(itineraryListProvider.notifier).addToItinerary(city);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${city.getName} added to itinerary"), duration: kSnackBarDuration),
                        );
                      }
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
          return SliverList.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return CityCardShimmer();
              }
          );
        }
    );
  }
}