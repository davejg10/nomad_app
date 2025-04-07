import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/screens/route_view/widgets/route_section_title.dart';

import '../../../widgets/city_criteria_bar.dart';

class ItineraryTotalsBar extends ConsumerWidget {
  const ItineraryTotalsBar({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Neo4jCity> itineraryList = ref.watch(itineraryListProvider);
    // Using SliverAppBar allows us to create the custom animation of having the route aggregates
    // float and be snapped back to UI if user scrolls back up
    return SliverAppBar(
      automaticallyImplyLeading: false, // Remove navigation arrow
      primary: false, // Already using a navbar
      expandedHeight: 210,
      pinned: false,
      scrolledUnderElevation: 16.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            const RouteSectionTitle(
                title: 'City averages'),
            ...CityCriteria.values.map((criteria) {
              return CityCriteriaBar(
                  cityCriteria: criteria,
                  metric: ref.read(itineraryListProvider.notifier).calculateCityCriteriaTotal(criteria)
              );
            }),
          ],
        ),
      ),
    );
  }
}
