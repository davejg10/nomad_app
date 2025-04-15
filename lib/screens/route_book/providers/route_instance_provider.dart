import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/domain/transport_type.dart';

import '../../../domain/neo4j/neo4j_city.dart';
import '../../../providers/repository_providers.dart';

final routeInstanceProvider = AsyncNotifierProvider<RouteInstanceNotifier, Set<RouteInstance>>(
    () => RouteInstanceNotifier(),
);

class RouteInstanceNotifier extends AsyncNotifier<Set<RouteInstance>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('route_instance_provider.dart'));
  // static final preferredTransportTypeOrder = ['ALL', 'FLIGHT', 'TRAIN', 'BUS', 'FERRY', 'VAN', 'Other'];

  @override
  FutureOr<Set<RouteInstance>> build() {
    return {};
  }

  // SourceCity & TargetCity are required to make a ServiceBus request if we cant find RouteInstances existing in our Psql DB
  Future<void> fetchRouteInstance(Neo4jCity sourceCity, Neo4jCity targetCity, DateTime searchDate) async {
    Set<Neo4jRoute> routes = sourceCity.getRoutes;
    state = const AsyncValue.loading();
    List<String> routeInstanceIds = routes.map((route) => route.getId).toList();

    state = await AsyncValue.guard(() => ref.read(routeInstanceRepositoryProvider).findRouteInstancesByRouteDefinitionIdInAndSearchDate(sourceCity, targetCity, routeInstanceIds, searchDate));
  }

}