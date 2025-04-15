import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/select_city/widgets/city_card/city_list_view_sliver.dart';
import 'package:nomad/screens/select_city/widgets/city_searchbar.dart';
import 'package:nomad/screens/select_city/widgets/last_city_tile.dart';
import 'package:nomad/screens/select_city/widgets/scrollable_bottom_sheet/scrollable_bottom_sheet.dart';
import 'package:nomad/screens/select_city/widgets/scrollable_bottom_sheet/travel_preferences_form.dart';
import 'package:nomad/screens/select_city/widgets/select_city_app_bar.dart';
import 'package:nomad/widgets/generic/error_snackbar.dart';

import '../../constants.dart';
import '../../widgets/generic/screen_scaffold.dart';
import 'providers/available_city_queried_list_provider.dart';

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

    bool searchBarOpen = ref.watch(widgetVisibilityProvider(WidgetVisibilityProviderIdentifier.SELECT_CITY_SEARCHBAR));
    return ScreenScaffold(
      padding: EdgeInsets.zero,
      appBar: const SelectCityAppBar(),
      child: Stack(
        children: [
          Padding(
            padding: kSidePadding,
            child: Column(
              children: [
                if (searchBarOpen)
                  const Padding(
                    padding: kSearchBarPadding,
                    child: CitySearchbar()
                  ),
                const Expanded(
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      LastCityTile(),
                      CityListView(),
                      SliverToBoxAdapter(child: SizedBox(height: 70,))
                    ],
                  )
                ),
                //
              ],
            ),
          ),
          ScrollableBottomSheet(
            sheetContent:  [
              TravelPreferencesForm()
            ],
          )
        ],
      )
    );
  }

}

