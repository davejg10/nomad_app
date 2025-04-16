import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/screens/route_book/providers/categorized_route_instances_provider.dart';
import 'package:nomad/screens/route_book/providers/route_instance_filter_provider.dart';
import 'package:nomad/screens/route_book/providers/route_instance_provider.dart';
import 'package:nomad/screens/route_book/route_instance_constants.dart';
import 'package:nomad/screens/route_book/widgets/app_bar/route_book_tab_bar_shimmer.dart';
import 'package:nomad/screens/route_book/widgets/app_bar/sort_popup_menu.dart';
import 'package:nomad/widgets/single_date_picker.dart';

class RouteBookAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const RouteBookAppBar({
    super.key,
    required this.sourceCity,
    required this.targetCity,
    required this.searchDate,
    required this.tabController,
    required this.tabs,
    required this.innerBoxIsScrolled
  });

  final Neo4jCity sourceCity;
  final Neo4jCity targetCity;
  final DateTime searchDate;
  final TabController tabController;
  final List<Widget> tabs;
  final bool innerBoxIsScrolled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(categorizedRouteInstanceProvider);
    String selectedSortOption = ref.watch(routeInstanceSortOptionProvider);

    return SliverAppBar(
      title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text('${sourceCity.getName} -> ${targetCity.getName}')
      ),
      actions: [
        SortPopupMenu(selectedSortOption: selectedSortOption),
        SingleDatePicker(
            onDateSubmitted: (DateTime selectedSearchDate) {
              ref.read(routeInstanceProvider.notifier).fetchRouteInstance(sourceCity, targetCity, selectedSearchDate);
            },
            lastDateSelected: searchDate
        ),
      ],
      pinned: true,
      floating: true,
      forceElevated: innerBoxIsScrolled,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10),
        child: TabBar(
          controller: tabController,
          tabs:  tabs,
        ),
      ),
    );
  }

  // In order to create this wrapper around AppBar and return it to param that is expecting Appbar we have to implement PreferedSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight + 10);
}
