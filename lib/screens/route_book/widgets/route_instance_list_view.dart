import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/domain/transport_type.dart';
import 'package:nomad/screens/route_book/widgets/route_instance_card.dart';
import 'package:nomad/screens/route_book/widgets/route_instance_sort_indicator.dart';
import 'package:nomad/screens/route_view/providers/itinerary_index_provider.dart';
import 'package:nomad/screens/route_view/providers/route_list_provider.dart';
import 'package:nomad/widgets/generic/add_remove_dialogue.dart';

class RouteInstanceListView extends ConsumerStatefulWidget {
  const RouteInstanceListView({
    super.key,
    required this.tabKey,
    required this.routeInstancesForTransportType,
    required this.transportType,
  });

  final PageStorageKey tabKey;
  final List<RouteInstance> routeInstancesForTransportType;
  final TransportType transportType;

  @override
  ConsumerState<RouteInstanceListView> createState() => _RouteInstanceListViewState();
}

class _RouteInstanceListViewState extends ConsumerState<RouteInstanceListView> with AutomaticKeepAliveClientMixin {
  static Logger _logger = Logger(
      printer: CustomLogPrinter('route_instance_list_view.dart'));

  @override
  bool get wantKeepAlive => true; // Keep the state!

  @override
  void initState() {
    super.initState();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    _logger.w('[${widget.transportType.name}] Offset: ${notification.metrics.pixels}');

    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // KeepAlive mixin needs this

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Builder(
        builder: (context) {
          return CustomScrollView(
            key: widget.tabKey,
            slivers: [
              SliverOverlapInjector(
                // This is the flip side of the SliverOverlapAbsorber above.
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverToBoxAdapter(
                child: RouteInstanceSortIndicator(),
              ),
              SliverList.builder(
                itemCount: widget.routeInstancesForTransportType.length,
                itemBuilder: (context, index) {
                  RouteInstance routeInstance = widget.routeInstancesForTransportType[index];
                  return Padding(
                    padding: EdgeInsets.zero,
                    child: RouteInstanceCard(
                      routeInstance: routeInstance,
                      transportType: widget.transportType,
                      leadingActionText: 'Select',
                      leadingActionOnPressed: () async {
                        final bool? confirmed = await showAddRemoveDialogue(
                            context: context,
                            contextName: widget.transportType.getTabName(),
                            action: ConfirmationAction.add,
                            onConfirm: () {
                              int itineraryIndex = ref.read(itineraryIndexProvider)!;
                              ref.read(routeListProvider.notifier).addToRouteList(itineraryIndex, routeInstance);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${widget.transportType.getTabName()} added as transport"), duration: kSnackBarDuration),
                              );
                            });
                      },
                    ),
                  );
                },
              ),
            ],
          );
        }
      ),
    );

  }
}
