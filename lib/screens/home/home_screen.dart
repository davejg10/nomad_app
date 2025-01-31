import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
import 'package:nomad/providers/logger_provider.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/home/providers/queried_country_list_provider.dart';
import 'package:nomad/screens/home/widgets/country_searchbar.dart';
import 'package:nomad/widgets/error_snackbar.dart';
import 'package:nomad/widgets/screen_scaffold.dart';
import 'package:nomad/screens/home/widgets/country_list_view.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    Logger logger = ref.read(loggerProvider('home_screen.dart'));

    ref.listen<AsyncValue>(
      queriedCountriesListProvider,
      (_, state) {
        return state.showSnackbarOnError(context, logger);
      },
    );

    bool searchResultsOpen = ref.watch(searchWidgetVisibility(SearchVisibility.SEARCH_RESULTS));
    return ScreenScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: kSearchBarPadding,
              child: CountrySearchbar(),
            ),
            if (searchResultsOpen)
              Flexible(
                child: CountryListView(),
              )
          ],
        ),
      ),
    );
  }
}