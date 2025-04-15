import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/screens/route_book/providers/route_instance_provider.dart';
import 'package:nomad/screens/route_view/providers/itinerary_index_provider.dart';
import 'package:nomad/screens/route_view/providers/route_list_provider.dart';
import 'package:nomad/screens/route_view/widgets/route_instance_selected_dialogue.dart';
import 'package:nomad/screens/route_view/widgets/route_view_date_picker.dart';
import 'package:nomad/widgets/generic/icon_background_button.dart';
import 'package:nomad/widgets/shimmer_loading.dart';
import 'package:nomad/widgets/single_date_picker.dart';

import '../../../domain/neo4j/neo4j_city.dart';
import '../../route_book/route_book_screen.dart';

class RouteIllustration extends ConsumerWidget {
  RouteIllustration({
    super.key,
    required this.sourceCity,
    required this.targetCity,
    required this.itineraryIndex
  });

  final Neo4jCity sourceCity;
  final Neo4jCity targetCity;
  final int itineraryIndex;
  final dateFormat = DateFormat('EEE, MMM d');
  final timeFormat = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(routeListProvider);
    bool isRouteChosen = ref.read(routeListProvider).containsKey(itineraryIndex);
    RouteInstance? routeInstance;
    if (isRouteChosen) {
      routeInstance = ref.read(routeListProvider.notifier).getRouteInstance(itineraryIndex);
    }

    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              IconBackgroundButton(
                icon: routeInstance!.getTransportType.getIcon(),
                backgroundColor: routeInstance.getTransportType.getColor(),
                onPressed: () async {
                  ref.read(itineraryIndexProvider.notifier).state = itineraryIndex;
                  ref.read(routeInstanceProvider.notifier).fetchRouteInstance(sourceCity, targetCity, routeInstance!.getDeparture);
                  bool? confirmed = await showRouteInstanceSelectedDialogue(
                    context: context,
                    routeInstance: routeInstance,
                    sourceCity: sourceCity,
                    targetCity: targetCity,
                    itineraryIndex: itineraryIndex
                  );
                },
                padding: EdgeInsets.all(4)
              ),

              const Icon(
                Symbols.south,
                weight: 150,
                size: 80,
                opticalSize: 6.0,
                fill: 1,
              ),
            ],
          ),
        ),

        Positioned(
          right: 10,
          top: 0,
          child: Text(
            '${dateFormat.format(ref.read(routeListProvider)[itineraryIndex]!.getDeparture)}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,

            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 20,
          child: Text(
            '${timeFormat.format(ref.read(routeListProvider)[itineraryIndex]!.getDeparture)}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,

            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 20,
          child: Text(
              '${dateFormat.format(ref.read(routeListProvider)[itineraryIndex]!.getArrival)}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,

            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 0,
          child: Text(
            '${timeFormat.format(ref.read(routeListProvider)[itineraryIndex]!.getArrival)}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,

            ),
          ),
        ),
      ],
    );
  }
}
