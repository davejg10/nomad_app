import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/domain/transport_type.dart';
import 'package:nomad/screens/route_book/widgets/route_instance_card.dart';
import 'package:nomad/screens/route_view/providers/itinerary_index_provider.dart';
import 'package:nomad/screens/route_view/providers/route_list_provider.dart';
import 'package:nomad/widgets/generic/add_remove_dialogue.dart';

class RouteInstanceListView extends ConsumerWidget {
  const RouteInstanceListView({
    super.key,
    required this.routeInstancesForTransportType,
    required this.transportType,
  });

  final List<RouteInstance> routeInstancesForTransportType;
  final TransportType transportType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      key: PageStorageKey(transportType), // Important for scroll position preservation
      itemCount: routeInstancesForTransportType.length,
      itemBuilder: (context, index) {
        RouteInstance routeInstance = routeInstancesForTransportType[index];
        return RouteInstanceCard(
          routeInstance: routeInstance,
          transportType: transportType,
          leadingActionText: 'Select',
          leadingActionOnPressed: () async {
            final bool? confirmed = await showAddRemoveDialogue(
              context: context,
              contextName: transportType.getTabName(),
              action: ConfirmationAction.add,
              onConfirm: () {
                int itineraryIndex = ref.read(itineraryIndexProvider)!;
                ref.read(routeListProvider.notifier).addToRouteList(itineraryIndex, routeInstance);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${transportType.getTabName()} added as transport"), duration: kSnackBarDuration),
                );
              });
            },
        );
      },
    );
  }
}
