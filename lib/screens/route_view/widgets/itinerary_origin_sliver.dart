import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/route_view/widgets/route_illustration.dart';

import '../../../widgets/city_card.dart';

class ItineraryOriginSliver extends ConsumerWidget {
  const ItineraryOriginSliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Neo4jCity originCity = ref.read(originCitySelectedProvider)!;
    final itineraryList = ref.watch(itineraryListProvider);
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: kCardPadding,
            child: CityCard(
              key: Key('cityCard${originCity.getName}'),
              lastCitySelected: originCity,
              selectedCity: originCity,
              routesToSelectedCity: Set.of({}),
              trailingIconButton: IconButton(
                icon: const Icon(Symbols.home),
                onPressed:  () {
                }
              ),
            ),
          ),
          if (itineraryList.isNotEmpty)
            RouteIllustration(sourceCity: originCity, targetCity: itineraryList[0], routes: originCity.getRoutes,)
        ]
      ),
    );
  }
}
