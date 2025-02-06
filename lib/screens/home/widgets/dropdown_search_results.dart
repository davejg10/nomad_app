import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/home/home_screen.dart';
import 'package:nomad/screens/home/widgets/geo_entity_card_shimmer.dart';

import '../../../domain/geo_entity.dart';
import '../../../providers/generic_queried_list_providers.dart';
import 'geo_entity_card.dart';

class DropdownSearchResults extends ConsumerWidget {
  const DropdownSearchResults({
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quieredListProviderState = ref.watch(queriedListProvider);

    return quieredListProviderState.when(
        data: (queriedList) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: queriedList.length,
            itemBuilder: (context, index) {
              GeoEntity geoEntity = queriedList.elementAt(index);
              return GeoEntityCard(
                key: Key('destinationCard${geoEntity.getName}'),
                geoEntity: geoEntity,
                cardOnTap: (GeoEntity geoEntity) {
                  ref.read(selectedDestinationProvider.notifier).setGeoEntity(geoEntity);
                  ref.read(queriedListProvider.notifier).reset();
                  searchController.closeView(geoEntity.getName);

                },
              );
            }
          );
        },
        error: (error, trace) {
          return Container();
        },
        loading: () {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: 4,
            itemBuilder: (context, index) {
              return GeoEntityCardShimmer();
            }
          );
        }
    );
  }
}
