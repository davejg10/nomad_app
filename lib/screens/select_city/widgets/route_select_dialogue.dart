import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/route_entity.dart';

import '../../../providers/route_list_provider.dart';

class RouteSelectDialogue extends ConsumerWidget {
  const RouteSelectDialogue({
    super.key,
    required this.routes
  });

  final Set<RouteEntity> routes;

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
            child: Text('Cost: ${route.getCost}, Time: ${route.getTime}, Popularity: ${route.getPopularity}, Method: ${route.getTransportType.name}')
          );
        })
      ],

    );
  }
}
