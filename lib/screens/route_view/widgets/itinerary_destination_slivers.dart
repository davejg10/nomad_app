import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/screens/route_view/widgets/route_illustration.dart';
import 'package:nomad/widgets/city_card.dart';

class ItineraryDestinationSlivers extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Neo4jRoute> routeList = ref.watch(routeListProvider);
    return SliverList.separated(
        itemCount: routeList.length,
        itemBuilder: (context, index) {
          Neo4jCity city = routeList[index].getTargetCity;
          return Padding(
            padding: kCardPadding,
            child: CityCard(
                key: Key('cityCard${city.getName}'),
                lastCitySelected: routeList[index - 1].getTargetCity,
                selectedCity: city,
                trailingIconButton: IconButton(
                  disabledColor: Colors.grey,
                  icon: const Icon(Symbols.close),
                  onPressed: index == routeList.length - 1  ? () {
                      ref.read(routeListProvider.notifier).removeLastFromItinerary();
                    }
                  : null,
                ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          index = index + 1;
          return RouteIllustration(routeEntity: routeList[index]);
        }
    );
  }
}