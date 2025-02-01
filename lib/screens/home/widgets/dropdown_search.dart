import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/providers/selected_destination_provider.dart';
import 'package:nomad/screens/home/widgets/dropdown_search_results.dart';

import '../../../providers/search_widget_visibility_provider.dart';
import '../providers/all_countries_provider.dart';
import '../providers/all_origin_cities_provider.dart';
import 'dropdown_searchbar.dart';

class DropdownSearch extends ConsumerStatefulWidget {
  const DropdownSearch({
    super.key,
    required this.dropdownIdentifier
  });

  final SearchWidgetIdentifier dropdownIdentifier;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DropdownSearchState();
}

class _DropdownSearchState extends ConsumerState<DropdownSearch> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchWidgetVisibilityProvider = searchWidgetVisibility(widget.dropdownIdentifier);
    bool searchResultsOpen = ref.watch(searchWidgetVisibilityProvider);
    bool isOriginCountry = widget.dropdownIdentifier == SearchWidgetIdentifier.ORIGIN_COUNTRY;
    bool isDestinationCountry = widget.dropdownIdentifier == SearchWidgetIdentifier.DESTINATION_COUNTRY;
    final queriedListProvider = isOriginCountry ? originCountryQueriedListProvider : isDestinationCountry ? destinationCountryQueriedListProvider : originCityQueriedListProvider;
    final selectedDestinationProvider = isOriginCountry ? originCountrySelectedProvider : isDestinationCountry ? destinationCountrySelectedProvider : originCitySelectedProvider;

    return Stack(
      children: [
        Padding(
          padding: kSearchBarPadding,
          child: DropdownSearchbar(
            dropdownIdentifier: widget.dropdownIdentifier,
            searchController: _searchController,
            focusNode: _focusNode,
            dropdownVisibilityProvider: searchWidgetVisibilityProvider,
            queriedListProvider: queriedListProvider,
            selectedDestinationProvider: selectedDestinationProvider
          ),
        ),
        if (searchResultsOpen)
          Positioned(
            top: kSearchBarPadding.top + 80, // Adjust based on your searchbar height
            left: kSearchBarPadding.left,
            right: kSearchBarPadding.right,
            child: Material(  // Wrap with Material to ensure proper elevation and interaction
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(  // Control the max height of results
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4, // Limit to 40% of screen height
                ),
                child: DropdownSearchResults(
                  dropdownIdentifier: widget.dropdownIdentifier,
                  searchController: _searchController,
                  focusNode: _focusNode,
                  dropdownVisibilityProvider: searchWidgetVisibilityProvider,
                  queriedListProvider: queriedListProvider,
                  selectedDestinationProvider: selectedDestinationProvider,
                )
              ),
            )
          )
      ],
    );
  }
}

