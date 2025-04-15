import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/screens/home/providers/selected_countries_provider.dart';
import 'package:nomad/screens/map_view/map_view_screen.dart';
import 'package:nomad/screens/route_view/providers/route_list_provider.dart';
import 'package:nomad/widgets/generic/screen_scaffold.dart';
import 'package:nomad/screens/route_view/widgets/itinerary_totals_bar.dart';

import '../../constants.dart';
import 'widgets/itinerary_destination_slivers.dart';

class RouteViewScreen extends ConsumerWidget {
  const RouteViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Set<Neo4jCountry> selectedCountries = ref.read(selectedCountryListProvider);
    return ScreenScaffold(
      appBar: AppBar(
        title: Text(
          selectedCountries.map((country) => country.getName).join(','),
          style: TextStyle(
              fontSize: 40,
              fontWeight: kFontWeight
          ),
        ),
        actions: [
            IconButton(
            icon: Icon(Icons.public),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MapViewScreen(
                    itinerary: ref.read(itineraryListProvider),
                    routeList: ref.read(routeListProvider),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ItineraryTotalsBar(),
                  ItineraryDestinationSlivers(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30.0),
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
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}