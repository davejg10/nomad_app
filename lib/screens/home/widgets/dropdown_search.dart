import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/home/home_screen.dart';
import 'package:nomad/screens/home/widgets/dropdown_search_anchor.dart';

import '../../../domain/geo_entity.dart';
import '../../../providers/generic_queried_list_providers.dart';
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

  late AsyncNotifierFamilyProvider<GenericQueriedListNotifier<GeoEntity>, Set<GeoEntity>, FutureProvider<Set<GeoEntity>>> queriedListProvider;
  late NotifierProvider<GeoEntitySelectedTemplate<GeoEntity>, GeoEntity?> selectedDestinationProvider;
  @override
  void initState() {
    super.initState();
    bool isOriginCountry = widget.dropdownIdentifier == DropdownIdentifier.ORIGIN_COUNTRY;
    bool isDestinationCountry = widget.dropdownIdentifier == DropdownIdentifier.DESTINATION_COUNTRY;

    queriedListProvider = isOriginCountry ? originCountryQueriedListProvider : isDestinationCountry ? destinationCountryQueriedListProvider : originCityQueriedListProvider;
    selectedDestinationProvider = isOriginCountry ? originCountrySelectedProvider : isDestinationCountry ? destinationCountrySelectedProvider : originCitySelectedProvider;

    if (ref.read(selectedDestinationProvider) != null) {
      _searchController.text = ref.read(selectedDestinationProvider)!.getName;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: kSearchBarPadding,
      child: DropdownSearchAnchor(
        dropdownIdentifier: widget.dropdownIdentifier,
        searchController: _searchController,
        focusNode: _focusNode,
        queriedListProvider: queriedListProvider,
        selectedDestinationProvider: selectedDestinationProvider
      ),
    );
  }
}

