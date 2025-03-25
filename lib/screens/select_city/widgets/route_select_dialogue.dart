import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';

import '../../../providers/route_list_provider.dart';

class RouteSelectDialogue extends ConsumerWidget {
  const RouteSelectDialogue({
    super.key,
    required this.routes
  });

  final Set<Neo4jRoute> routes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SimpleDialog(
      title: const Text('Choose your desired route'),
      children: <Widget>[
        ...routes.map((route) {
          return SimpleDialogOption(
            onPressed: () {
              ref.read(routeListProvider.notifier).addToItinerary(route);
              Navigator.pop(context);
            },
            child: Text('Cost: ${route.getAverageCost}, Time: ${route.getAverageDuration}, Popularity: ${route.getPopularity}, Method: ${route.getTransportType.name}')
          );
        })
      ],

    );
  }
}
