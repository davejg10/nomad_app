import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/screens/route_view/providers/route_list_provider.dart';
import 'package:nomad/screens/route_view/widgets/route_illustration.dart';
import 'package:nomad/screens/route_view/widgets/route_view_date_picker.dart';
import 'package:nomad/widgets/city_card/city_card.dart';
import 'package:nomad/widgets/generic/add_remove_dialogue.dart';

import '../../../custom_log_printer.dart';

class ItineraryDestinationSlivers extends ConsumerWidget {
  Logger _logger = Logger(printer: CustomLogPrinter('itinerary_destination_slivers.dart'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(routeListProvider);
    List<Neo4jCity> itineraryList = ref.watch(itineraryListProvider);
    return SliverList.separated(
        itemCount: itineraryList.length,
        itemBuilder: (context, index) {
          Neo4jCity lastCity =  index == 0 ? itineraryList[index] : itineraryList[index - 1];
          Neo4jCity city = itineraryList[index];
          bool isRouteSelected = ref.read(routeListProvider).containsKey(index);

          return CityCard(
              key: Key('cityCard${city.getName}'),
              lastCitySelected: lastCity,
              selectedCity: city,
              trailingButton:
                index == itineraryList.length - 1
                ?
                  IconButton(
                    icon: const Icon(Symbols.close),
                    onPressed: () async {
                      final bool? confirmed = await showAddRemoveDialogue(
                          context: context,
                          contextName: city.getName,
                          action: ConfirmationAction.remove,
                          onConfirm: () {});
                      if (confirmed == true) {
                        ref.read(itineraryListProvider.notifier).removeLastFromItinerary();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              "${city.getName} removed from itinerary"),
                              duration: Duration(seconds: 2)),
                        );
                      }
                    }
                  )
                : !isRouteSelected ?
                  RouteViewDatePicker(
                    sourceCity: city,
                    targetCity: itineraryList[index + 1],
                    itineraryIndex: index,
                  )
                :
                  null
          );
        },
        separatorBuilder: (context, index) {
          bool isRouteSelected = ref.read(routeListProvider).containsKey(index);
          if (isRouteSelected) {
            Neo4jCity sourceCity = itineraryList[index];
            Neo4jCity targetCity = itineraryList[index + 1];
            return RouteIllustration(
                sourceCity: sourceCity,
                targetCity: targetCity,
                itineraryIndex: index
            );
          } else {
            return SizedBox.shrink();
          }
        }
    );
  }
}