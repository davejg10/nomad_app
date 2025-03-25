import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/route_view/widgets/itinerary_origin_sliver.dart';
import 'package:nomad/widgets/screen_scaffold.dart';
import 'package:nomad/screens/route_view/widgets/itinerary_totals_bar.dart';

import '../../constants.dart';
import 'widgets/itinerary_destination_slivers.dart';

class RouteViewScreen extends ConsumerWidget {
  const RouteViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Neo4jCountry country = ref.read(destinationCountrySelectedProvider)!;
    return ScreenScaffold(
      appBar: AppBar(
        title: Text(
          country.getName,
          style: TextStyle(
              fontSize: 40,
              fontWeight: kFontWeight
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              // decoration: kSunkenBoxDecoration,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  ItineraryTotalsBar(),
                  ItineraryOriginSliver(),
                  ItineraryDestinationSlivers()
                ],
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}