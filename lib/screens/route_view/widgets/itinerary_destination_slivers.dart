import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/route_view/widgets/route_illustration.dart';
import 'package:nomad/widgets/city_card.dart';

import '../../../custom_log_printer.dart';

class ItineraryDestinationSlivers extends ConsumerWidget {
  Logger _logger = Logger(printer: CustomLogPrinter('itinerary_destination_slivers.dart'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Neo4jCity> itineraryList = ref.watch(itineraryListProvider);
    Neo4jCity originCity = ref.read(originCitySelectedProvider)!;
    return SliverList.separated(
        itemCount: itineraryList.length,
        itemBuilder: (context, index) {
          Neo4jCity lastCity =  index == 0 ? originCity : itineraryList[index - 1];
          Neo4jCity city = itineraryList[index];
          _logger.w("lastCity routes size: ${lastCity.getRoutes.length}");

          return Padding(
            padding: kCardPadding,
            child: CityCard(
                key: Key('cityCard${city.getName}'),
                lastCitySelected: lastCity,
                selectedCity: city,
                routesToSelectedCity: lastCity.getRoutes,
                trailingIconButton: IconButton(
                  disabledColor: Colors.grey,
                  icon: const Icon(Symbols.close),
                  onPressed: index == itineraryList.length - 1  ? () {
                      ref.read(itineraryListProvider.notifier).removeLastFromItinerary();
                    }
                  : null,
                ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          Neo4jCity sourceCity = itineraryList[index];
          Neo4jCity targetCity = itineraryList[index + 1];
          return RouteIllustration(sourceCity: sourceCity, targetCity: targetCity, routes: sourceCity.getRoutes);
        }
    );
  }
}