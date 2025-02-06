import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/geo_entity.dart';
import 'package:nomad/providers/generic_queried_list_providers.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/home/home_screen.dart';
import 'package:nomad/screens/home/widgets/dropdown_search_results.dart';
import 'package:nomad/widgets/error_snackbar.dart';

class DropdownSearchanchor extends ConsumerWidget {
  DropdownSearchanchor({
    super.key,
    required this.dropdownIdentifier,
    required this.searchController,
    required this.focusNode,
    required this.queriedListProvider,
    required this.selectedDestinationProvider,
  });
  final DropdownIdentifier dropdownIdentifier;
  final SearchController searchController;
  final FocusNode focusNode;
  final AsyncNotifierFamilyProvider<GenericQueriedListNotifier<GeoEntity>, Set<GeoEntity>, FutureProvider<Set<GeoEntity>>> queriedListProvider;
  final NotifierProvider<GeoEntitySelectedTemplate<GeoEntity>, GeoEntity?> selectedDestinationProvider;

  String getHintText() {
    switch (dropdownIdentifier) {
      case DropdownIdentifier.ORIGIN_COUNTRY:
        return 'England';
      case DropdownIdentifier.DESTINATION_COUNTRY:
        return 'Thailand';
      default:
        return 'London';
    }
  }

  String getLeadingText() {
    switch (dropdownIdentifier) {
      case DropdownIdentifier.ORIGIN_COUNTRY:
        return 'From country:';
      case DropdownIdentifier.DESTINATION_COUNTRY:
        return 'To country:';
      default:
        return 'From city:';
    }
  }

  RoundedRectangleBorder searchShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners
  );


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCityDropdown = dropdownIdentifier == DropdownIdentifier.ORIGIN_CITY;
    GeoEntity? originCountrySelected = ref.watch(originCountrySelectedProvider);
    if (isCityDropdown) {
      // The actual state is reset in `originCountrySelectedProvider` but this clears the originCity populated field
      searchController.text = '';
    }

    return SearchAnchor(
      viewConstraints: BoxConstraints(maxHeight: 300),
      viewShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      enabled: isCityDropdown && originCountrySelected == null ? false : true,
      viewLeading: Text(getLeadingText()),
      viewTrailing: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            searchController.closeView('');
            ref.read(queriedListProvider.notifier).reset();
            ref.invalidate(selectedDestinationProvider);
          },
        )
      ],
      viewBuilder: (_) {
        // Constructing the List of search result Widgets here rather than suggestionBuilder as it allows us to use lazy initialization for the widgets.
        return DropdownSearchResults(
          dropdownIdentifier: dropdownIdentifier,
          searchController: searchController,
          focusNode: focusNode,
          queriedListProvider: queriedListProvider,
          selectedDestinationProvider: selectedDestinationProvider,
        );
      },
      viewOnSubmitted: (userInput) {
        GeoEntity? geoEntity = ref.read(queriedListProvider.notifier).submit(userInput);
        if (geoEntity != null) {
          ref.read(selectedDestinationProvider.notifier).setGeoEntity(geoEntity);
          ref.read(queriedListProvider.notifier).reset();
          searchController.closeView(geoEntity.getName);
        } else {
          focusNode.requestFocus();
          ScaffoldMessenger.of(context).showSnackBar(
              ErrorSnackbar(
                  '$userInput is not a valid destination in our list...')
          );
        }
      },
      isFullScreen: false,
      searchController: searchController,
      viewOnChanged: (userInput) {
        ref.read(queriedListProvider.notifier).filter(userInput);
      },
      builder: (BuildContext context, SearchController searchController) {
        return SearchBar(
          hintText: getHintText(),
          hintStyle: WidgetStateProperty.all(
            TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            searchShape
          ),
          controller: searchController,
          leading: Text(getLeadingText()),
          trailing: [
            IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                searchController.openView();
              },
            ),
          ],
          onTap: () {
            if (!searchController.isOpen) {
              searchController.openView();
            }
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController searchController) {
        return [Text('required but not used - this allows us to provide our own ListView.Builder above for lazy loading...')];
      }
    );
  }
}
