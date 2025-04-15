import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/screens/route_book/providers/route_instance_provider.dart';
import 'package:nomad/screens/route_book/route_book_screen.dart';
import 'package:nomad/screens/route_view/providers/itinerary_index_provider.dart';
import 'package:nomad/widgets/generic/single_date_picker_dialogue.dart';
import 'package:nomad/widgets/shimmer_loading.dart';
import 'package:shimmer/shimmer.dart';

class RouteViewDatePicker extends ConsumerWidget {
  const RouteViewDatePicker({
    super.key,
    required this.sourceCity,
    required this.targetCity,
    required this.routes,
    required this.itineraryIndex
  });
  final Neo4jCity sourceCity;
  final Neo4jCity targetCity;
  final Set<Neo4jRoute> routes;
  final int itineraryIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Card(
      elevation: 3,
      shape: kButtonShape,
      color: Theme.of(context).primaryColor,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          ref.read(itineraryIndexProvider.notifier).state = itineraryIndex;
          DateTime? selectedDate = await showSingleDatePickerDialogue(ref: ref, context: context);
          if (selectedDate != null) {
            ref.read(routeInstanceProvider.notifier).fetchRouteInstance(sourceCity, targetCity, routes, selectedDate);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RouteBookScreen(
                  sourceCity: sourceCity,
                  targetCity: targetCity,
                  routes: routes,
                  searchDate: selectedDate
                ),
              ),
            );
          };
        },
        icon: const Icon(
          Symbols.calendar_month,
          color: Colors.white, // Icon color
          size: 24,
        ),
      ),
    );
  }
}
