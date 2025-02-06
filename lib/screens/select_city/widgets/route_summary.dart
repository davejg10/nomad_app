import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/providers/route_list_provider.dart';

import '../../../constants.dart';
import '../../../domain/city.dart';

class RouteSummary extends ConsumerWidget {
  RouteSummary({super.key});
  static Logger _logger = Logger(printer: CustomLogPrinter('route_summary.dart'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<RouteEntity> routeList = ref.watch(routeListProvider);
    return Container(
      alignment: Alignment.topLeft,
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route summary:',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: kFontWeight,
            ),
          ),
          Container(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [Text(
                routeList.map((route) => route.getTargetCity.getName).join(' -> '),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.0),
              )],
            ),
          ),
        ],
      ),
    );
  }
}