import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/home/home_screen.dart';
import 'package:nomad/screens/home/widgets/dropdown_searchanchor.dart';

import '../providers/providers.dart';

class DropdownSearch extends ConsumerStatefulWidget {
  const DropdownSearch({
    super.key,
    required this.dropdownIdentifier
  });

  final DropdownIdentifier dropdownIdentifier;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DropdownSearchState();
}

class _DropdownSearchState extends ConsumerState<DropdownSearch> {
  final FocusNode _focusNode = FocusNode();
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isOriginCountry = widget.dropdownIdentifier == DropdownIdentifier.ORIGIN_COUNTRY;
    bool isDestinationCountry = widget.dropdownIdentifier == DropdownIdentifier.DESTINATION_COUNTRY;

    final queriedListProvider = isOriginCountry ? originCountryQueriedListProvider : isDestinationCountry ? destinationCountryQueriedListProvider : originCityQueriedListProvider;
    final selectedDestinationProvider = isOriginCountry ? originCountrySelectedProvider : isDestinationCountry ? destinationCountrySelectedProvider : originCitySelectedProvider;

    return Padding(
      padding: kSearchBarPadding,
      child: DropdownSearchanchor(
        dropdownIdentifier: widget.dropdownIdentifier,
        searchController: _searchController,
        focusNode: _focusNode,
        queriedListProvider: queriedListProvider,
        selectedDestinationProvider: selectedDestinationProvider
      ),
    );
  }
}

