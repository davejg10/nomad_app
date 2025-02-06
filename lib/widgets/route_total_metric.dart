import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/domain/route_metric.dart';
import 'package:nomad/providers/route_list_provider.dart';

import '../constants.dart';

class RouteTotalMetric extends ConsumerWidget {
  const RouteTotalMetric({super.key, required this.metric});

  final RouteMetric metric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<RouteEntity> routeList = ref.watch(routeListProvider);
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        '${metric.name} - ${ref.read(routeListProvider.notifier).calculateRouteMetricTotal(metric)}',
        style: const TextStyle(
            fontWeight: kFontWeight
        ),
      ),
    );
  }
}