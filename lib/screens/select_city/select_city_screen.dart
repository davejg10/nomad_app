import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_provider.dart';
import 'package:nomad/screens/select_city/widgets/city_searchbar.dart';
import 'package:nomad/screens/select_city/widgets/scrollable_bottom_sheet.dart';
import 'package:nomad/screens/select_city/widgets/select_city_app_bar.dart';
import 'package:nomad/widgets/error_snackbar.dart';

import '../../constants.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/travel_preference_slider.dart';
import 'providers/providers.dart';
import 'widgets/city_list_view.dart';

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
              TravelPreferenceSlider(travelPreference: CityCriteria.FOOD.name),
              Divider(height: 10,),
              TravelPreferenceSlider(travelPreference: CityCriteria.SAILING.name),
              Divider(height: 10,),
              TravelPreferenceSlider(travelPreference: CityCriteria.NIGHTLIFE.name),
              Divider(height: 10,),
              const TravelPreferenceSlider(travelPreference: 'COST'),
              ElevatedButton(
                onPressed: () {
                  ref.read(availableCityListProvider.notifier).fetchAllNextCities();
                },
                child: const Text('Apply changes'),
              )
            ],
          )
        ],
      )
    );
  }
}

