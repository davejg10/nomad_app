import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/domain/sql/route_instance.dart';

import '../../../domain/neo4j/neo4j_city.dart';
import '../../../providers/backend_repository_provider.dart';

final routeInstanceProvider = AsyncNotifierProvider<RouteInstanceNotifier, Set<RouteInstance>>(
    () => RouteInstanceNotifier(),
);

class RouteInstanceNotifier extends AsyncNotifier<Set<RouteInstance>> {

  @override
  FutureOr<Set<RouteInstance>> build() {
    return {};
  }

  Future<void> fetchRouteInstance(Neo4jCity sourceCity, Neo4jCity targetCity, Set<Neo4jRoute> routes, DateTime searchDate) async {
    state = const AsyncValue.loading();
    List<String> routeInstanceIds = routes.map((route) => route.getId).toList();

    state = await AsyncValue.guard(() => ref.read(backendRepositoryProvider).findRouteInstancesByRouteDefinitionIdInAndSearchDate(sourceCity, targetCity, routeInstanceIds, searchDate));
  }

}