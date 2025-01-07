import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/route_list_provider.dart';

import '../constants.dart';

class RouteTotalMetric extends ConsumerWidget {
  const RouteTotalMetric({super.key, required this.metric});

  final String metric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<City> routeList = ref.watch(routeListProvider);
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        '$metric - ${routeList.length}',
        style: const TextStyle(
            fontWeight: kFontWeight
        ),
      ),
    );
  }
}