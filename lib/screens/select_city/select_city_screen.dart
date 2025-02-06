import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/select_city/widgets/city_searchbar.dart';
import 'package:nomad/screens/select_city/widgets/scrollable_bottom_sheet.dart';
import 'package:nomad/screens/select_city/widgets/select_city_app_bar.dart';
import 'package:nomad/widgets/error_snackbar.dart';
import 'package:nomad/widgets/route_total_metric.dart';

import '../../constants.dart';
import '../../domain/route_metric.dart';
import '../../widgets/screen_scaffold.dart';
import 'providers/providers.dart';
import 'widgets/city_list_view.dart';
import '../../widgets/route_aggregate_card.dart';
import 'widgets/route_summary.dart';

class SelectCityScreen extends ConsumerWidget  {
  static Logger _logger = Logger(printer: CustomLogPrinter('select_city_screen.dart'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen<AsyncValue>(
      availableCityQueriedListProvider,
      (_, state) {
        return state.showSnackbarOnError(context, _logger);
      },
    );

    bool searchBarOpen = ref.watch(searchWidgetVisibility(SearchWidgetIdentifier.SELECT_CITY_SEARCHBAR));
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
                  ...RouteMetric.values.map((metric) {
                    return RouteTotalMetric(metric: metric);
                  })
                ],
              )
            ],
          )
        ],
      )
    );
  }
}

