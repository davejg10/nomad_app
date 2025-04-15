import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/screens/route_book/providers/categorized_route_instances_provider.dart';
import 'package:nomad/screens/route_book/providers/route_instance_filter_provider.dart';
import 'package:nomad/screens/route_book/route_instance_constants.dart';

class SortPopupMenu extends ConsumerWidget {
  const SortPopupMenu({
    super.key,
    required this.selectedSortOption
  });

  final String selectedSortOption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: Container(
        width: 30,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: kContainerShape
        ),
        child: Icon(Icons.filter_alt),
      ),
      tooltip: 'Sort routes',
      onSelected: (String value) {
        ref.read(routeInstanceSortOptionProvider.notifier).setSortOption(value);
        ref.read(categorizedRouteInstanceProvider.notifier).sortMapValuesByFilter(value);
      },
      itemBuilder: (BuildContext context) {
        return kRouteInstanceFilter.map((String option) {
          return PopupMenuItem<String>(
            value: option,
            child: Row(
              children: [
                selectedSortOption == option
                    ? const Icon(Icons.check, size: 16)
                    : const SizedBox(width: 16),
                const SizedBox(width: 8),
                Text(option),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
