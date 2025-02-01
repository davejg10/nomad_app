import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/selected_destination_provider.dart';
import 'package:nomad/widgets/error_snackbar.dart';

import '../../../domain/destination.dart';
import '../../../providers/generic_queried_list_providers.dart';
import '../../../providers/search_widget_visibility_provider.dart';

class DropdownSearchbar<T> extends ConsumerWidget {
  const DropdownSearchbar({
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

  String getHintText() {
    switch (dropdownIdentifier) {
      case SearchWidgetIdentifier.ORIGIN_COUNTRY:
        return 'England';
      case SearchWidgetIdentifier.DESTINATION_COUNTRY:
        return 'Thailand';
      default:
        return 'London';
    }
  }

  String getLeadingText() {
    switch (dropdownIdentifier) {
      case SearchWidgetIdentifier.ORIGIN_COUNTRY:
        return 'From country:';
      case SearchWidgetIdentifier.DESTINATION_COUNTRY:
        return 'To country:';
      default:
        return 'From city:';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dropdownVisibilityProvider);
    final dropdownVisibilityNotifier = ref.read(dropdownVisibilityProvider.notifier);

    return SearchBar(
      onSubmitted: (userInput) {

        Destination? submittedDestination = ref.read(queriedListProvider.notifier).submit(userInput);
        if (submittedDestination != null) {
          ref.read(selectedDestinationProvider.notifier).setDestination(submittedDestination);
          ref.read(queriedListProvider.notifier).reset();
          searchController.text = submittedDestination.getName;
          dropdownVisibilityNotifier.close();
        } else {
          focusNode.requestFocus();
          ScaffoldMessenger.of(context).showSnackBar(
              ErrorSnackbar(
                  '$userInput is not a valid destination in our list...')
          );
        }
      },
      onTap: () {
        dropdownVisibilityNotifier.open();
      },
      onChanged: (userInput) {
        ref.read(queriedListProvider.notifier).filter(userInput);
      },
      controller: searchController,
      focusNode: focusNode,
      hintText: getHintText(),
      constraints: BoxConstraints(minHeight: 80),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
      leading: Text(getLeadingText()),
      trailing: [
        (dropdownVisibilityNotifier.isOpen()) ?
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              searchController.text = '';
              dropdownVisibilityNotifier.close();
              ref.read(queriedListProvider.notifier).reset();
            },
          )
        :
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              dropdownVisibilityNotifier.open();
            },
          ),
      ]
    );
  }
}
