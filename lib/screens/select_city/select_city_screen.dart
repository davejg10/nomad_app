import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/select_city/widgets/city_searchbar.dart';
import 'package:nomad/screens/select_city/widgets/scrollable_bottom_sheet.dart';
import 'package:nomad/screens/select_city/widgets/select_city_app_bar.dart';
import 'package:nomad/widgets/route_total_metric.dart';

import '../../constants.dart';
import '../../domain/route_metric.dart';
import '../../widgets/screen_scaffold.dart';
import 'widgets/city_list_view.dart';
import '../../widgets/route_aggregate_card.dart';
import 'widgets/route_summary.dart';

class SelectCityScreen extends ConsumerWidget  {


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool searchBarOpen = ref.watch(searchWidgetVisibility(SearchVisibility.SEARCHBAR));
    return ScreenScaffold(
      padding: EdgeInsets.zero, //Allows ScrollSheet to be full width of screen
      appBar: SelectCityAppBar(),
      child: Stack(
        children: [
          Padding(
            padding: kSidePadding,
            child: Column(
              children: [
                if (searchBarOpen)
                  Padding(
                    padding: kSearchBarPadding,
                    child: CitySearchbar()
                  ),
                Expanded(child: CityListView(),),
              ],
            ),
          ),
          ScrollableBottomSheet(
            sheetContent:  [
              RouteSummary(),
              RouteAggregateCard(
                boxConstraints: BoxConstraints(maxHeight: 100, maxWidth: 125),
                columnChildren: [
                  RouteTotalMetric(metric: RouteMetric.WEIGHT.name),
                  RouteTotalMetric(metric: RouteMetric.COST.name),
                  RouteTotalMetric(metric: RouteMetric.POPULARITY.name)
                ],
              )
            ],
          )
        ],
      )
    );
  }
}

