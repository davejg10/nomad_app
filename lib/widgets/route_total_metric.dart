// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nomad/domain/neo4j/neo4j_route.dart';
// import 'package:nomad/domain/route_metric.dart';
// import 'package:nomad/providers/itinerary_list_provider.dart';
//
// import '../constants.dart';
//
// class RouteTotalMetric extends ConsumerWidget {
//   const RouteTotalMetric({super.key, required this.metric});
//
//   final RouteMetric metric;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     List<Neo4jRoute> routeList = ref.watch(routeListProvider);
//
//     double total = metric == RouteMetric.AVERAGE_COST ? ref.read(routeListProvider.notifier).calculateRouteCostTotal(metric) : ref.read(routeListProvider.notifier).calculateRouteMetricTotal(metric);
//     return FittedBox(
//       fit: BoxFit.contain,
//       child: Text(
//         '${metric.name} - $total',
//         style: const TextStyle(
//             fontWeight: kFontWeight
//         ),
//       ),
//     );
//   }
// }