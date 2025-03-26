import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/screens/route_book/providers/route_instance_provider.dart';
import 'package:nomad/widgets/single_date_select.dart';

import '../../../custom_log_printer.dart';
import '../../../domain/neo4j/neo4j_city.dart';
import '../../route_book/route_book_screen.dart';

class RouteIllustration extends ConsumerWidget {


  const RouteIllustration({
    super.key,
    required this.sourceCity,
    required this.targetCity,
    required this.routes
  });
  final Neo4jCity sourceCity;
  final Neo4jCity targetCity;
  final Set<Neo4jRoute> routes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          SingleDateSelect(onDateSubmitted: (DateTime selectedDate) {
            ref.read(routeInstanceProvider.notifier).fetchRouteInstance(sourceCity, targetCity, routes, selectedDate);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RouteBookScreen(sourceCity: sourceCity, targetCity: targetCity, routes: routes, searchDate: selectedDate),
              ),
            );
          }),
          const Icon(
            Symbols.arrow_cool_down,
            weight: 150,
            size: 80,
            opticalSize: 6.0,
            fill: 1,
          ),
        ],
      ),
    );
  }
}
