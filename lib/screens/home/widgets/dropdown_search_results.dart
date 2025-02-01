import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/selected_destination_provider.dart';
import 'package:nomad/screens/home/widgets/destination_card_shimmer.dart';

import '../../../domain/destination.dart';
import '../../../providers/generic_queried_list_providers.dart';
import '../../../providers/search_widget_visibility_provider.dart';
import 'destination_card.dart';

class DropdownSearchResults extends ConsumerWidget {
  const DropdownSearchResults({
    super.key,
    required this.dropdownIdentifier,
    required this.searchController,
    required this.focusNode,
    required this.dropdownVisibilityProvider,
    required this.queriedListProvider,
    required this.selectedDestinationProvider,
  });
  final SearchWidgetIdentifier dropdownIdentifier;
  final TextEditingController searchController;
  final FocusNode focusNode;
  final NotifierFamilyProvider<SearchWidgetVisibility, bool, SearchWidgetIdentifier> dropdownVisibilityProvider;
  final AsyncNotifierFamilyProvider<GenericQueriedListNotifier<Destination>, Set<Destination>, FutureProvider<Set<Destination>>> queriedListProvider;
  final NotifierProvider<SelectedDestination<Destination>, Destination?> selectedDestinationProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quieredListProviderState = ref.watch(queriedListProvider);

    return quieredListProviderState.when(
        data: (queriedList) {
          return ListView.builder(
              itemCount: queriedList.length,
              itemBuilder: (context, index) {
                Destination destination = queriedList.elementAt(index);
                return DestinationCard(
                  key: Key('destinationCard${destination.getName}'),
                  destination: destination,
                  cardOnTap: (Destination destination) {
                    ref.read(selectedDestinationProvider.notifier).setDestination(destination);
                    searchController.text = destination.getName;
                    ref.read(dropdownVisibilityProvider.notifier).close();
                    ref.read(queriedListProvider.notifier).reset();
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
              itemCount: 4,
              itemBuilder: (context, index) {
                return DestinationCardShimmer();
              }
          );
        }
    );
  }
}
