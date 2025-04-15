import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/screens/route_book/providers/categorized_route_instances_provider.dart';
import 'package:nomad/screens/route_book/providers/route_instance_filter_provider.dart';
import 'package:nomad/screens/route_book/providers/route_instance_provider.dart';
import 'package:nomad/screens/route_book/route_instance_constants.dart';
import 'package:nomad/screens/route_book/widgets/app_bar/route_book_app_bar.dart';
import 'package:nomad/screens/route_book/widgets/app_bar/route_book_tab_bar_shimmer.dart';
import 'package:nomad/screens/route_book/widgets/app_bar/sort_popup_menu.dart';
import 'package:nomad/screens/route_book/widgets/route_instance_list_view.dart';
import 'package:nomad/screens/route_book/widgets/route_instance_list_view_loading.dart';
import 'package:nomad/screens/route_book/widgets/route_instance_sort_indicator.dart';
import 'package:nomad/widgets/generic/action_button_card.dart';
import 'package:nomad/widgets/generic/custom_not_found.dart';
import 'package:nomad/widgets/generic/error_snackbar.dart';
import 'package:nomad/widgets/generic/icon_background_button.dart';
import 'package:nomad/widgets/generic/screen_scaffold.dart';
import 'package:nomad/widgets/single_date_picker.dart';

import '../../custom_log_printer.dart';
import '../../domain/neo4j/neo4j_city.dart';
import '../../domain/sql/route_instance.dart';
import '../../domain/transport_type.dart';

class RouteBookScreen extends ConsumerStatefulWidget {
  const RouteBookScreen({
    super.key,
    required this.sourceCity,
    required this.targetCity,
    required this.searchDate,
  });

  final Neo4jCity sourceCity;
  final Neo4jCity targetCity;
  final DateTime searchDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RouteBookScreenState();
}

class _RouteBookScreenState extends ConsumerState<RouteBookScreen> with TickerProviderStateMixin {
  static Logger _logger = Logger(printer: CustomLogPrinter('route_book_screen.dart'));

  TabController? _tabController;
  late Set<RouteInstance> routeInstances;
  List<TransportType> _sortedTransportModes = [TransportType.FLIGHT, TransportType.FERRY]; // Initialize with dummy value for loading

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void reInitializeTabController(List<TransportType> newAvailableTransportTypes) {
    if (_tabController == null || _didModesChange(newAvailableTransportTypes)) {
      _sortedTransportModes = newAvailableTransportTypes; // Update stored modes
      _tabController?.dispose(); // Dispose old one if exists
      _tabController = TabController(
          length: _sortedTransportModes.length,
          vsync: this
      );
    }
  }

  bool _didModesChange(List<TransportType> newModes) {
    if (newModes.length != _sortedTransportModes.length) {
      return true;
    }
    for (int i = 0; i < newModes.length; i++) {
      if (newModes[i] != _sortedTransportModes[i]) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final categorizedRoutes = ref.watch(categorizedRouteInstanceProvider);
    final newAvailableTransportTypes = ref.read(categorizedRouteInstanceProvider.notifier).sortKeysByPreferredTransportType();
    final routeInstanceState = ref.watch(routeInstanceProvider);
    reInitializeTabController(newAvailableTransportTypes);

    DateTime _searchDate = widget.searchDate;
    String date = '${_searchDate.day}-${_searchDate.month}-${_searchDate.year}';

    return ScreenScaffold(
      padding: EdgeInsets.zero,
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder:  (context, innerBoxIsScrolled) => [
          RouteBookAppBar(
              sourceCity: widget.sourceCity,
              targetCity: widget.targetCity,
              searchDate: widget.searchDate,
              tabController: routeInstanceState.isLoading ? TabController(length: 2, vsync: this) : _tabController!,
              tabs: _buildRouteInstanceTabs(routeInstanceState.isLoading)
          ),
        ],
        body: Column(
          children: [
            RouteInstanceSortIndicator(),
            Expanded(
                child: _buildRouteInstanceListView(categorizedRoutes, routeInstanceState),
            ),
          ],
        ),
      )
    );
  }

  List<Widget> _buildRouteInstanceTabs(bool isLoading) {
    if (isLoading) {
      return List.generate(2, (index) =>
      const RouteBookTabBarShimmer(),
      );
    }
    return _sortedTransportModes.map((type) =>
        SizedBox(
          height: 60,
          child: Tab(
            icon: Icon(type.getIcon()),
            text: type.getTabName(),
          ),
        ),
    ).toList();
  }

  Widget _buildRouteInstanceListView(Map<TransportType, List<RouteInstance>> categorizedRoutes, AsyncValue<Set<RouteInstance>> routeInstanceState ) {
    if (routeInstanceState.isLoading) {
      return RouteInstanceListViewLoading();
    } else if (categorizedRoutes.isEmpty || routeInstanceState.hasError) {
      return const Center(
        child: CustomNotFound(thingNotFound: 'Routes',)
      );
    }
    return TabBarView(
      controller: _tabController,
      children: _sortedTransportModes.map((transportType) {
        return RouteInstanceListView(
          routeInstancesForTransportType: categorizedRoutes[transportType] ?? [],
          transportType: transportType,
        );
      }).toList(),
    );
  }
}
