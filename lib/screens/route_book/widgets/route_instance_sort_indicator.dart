import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/screens/route_book/providers/route_instance_filter_provider.dart';

class RouteInstanceSortIndicator extends ConsumerWidget {
  const RouteInstanceSortIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedSortOption = ref.watch(routeInstanceSortOptionProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          const Icon(Icons.sort, size: kStandardIconSize),
          const SizedBox(width: 8),
          Text(
            'Sorted by: $selectedSortOption',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
