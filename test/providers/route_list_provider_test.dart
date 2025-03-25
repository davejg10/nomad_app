import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/domain/neo4j_city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j_country.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/domain/route_metric.dart';
import 'package:nomad/domain/transport_type.dart';
import 'package:nomad/providers/route_list_provider.dart';

import '../riverpod_provider_container.dart';
import '../riverpod_state_listeners.dart';

void main() {

  group('routeListProvider', () {

    late ProviderContainer container;
    late StateListener listener;

    Map<CityCriteria, double> cityMetrics = {
      CityCriteria.SAILING: 8.0,
      CityCriteria.FOOD: 4.6,
      CityCriteria.NIGHTLIFE: 10.0
    };
    Country country0 = Country("0", 'Country0', 'Some country');
    City cityA = City("", "CityA", "", cityMetrics, [], country0);
    City cityB = City("", "CityB", "", cityMetrics, [], country0);
    Neo4jRoute aToB = Neo4jRoute("", 4.0, 3.2, 16.0, TransportType.BUS, cityB);
    Neo4jRoute aToBFlight = Neo4jRoute("", 4.0, 3.2, 30.0, TransportType.FLIGHT, cityB);
    Neo4jRoute bToA = Neo4jRoute("", 3.0, 4.2, 17.0, TransportType.BUS, cityA);

    setUp(() {
      // Creates a container containing all of our providers
      container = createContainer();

      listener = StateListener<List<Neo4jRoute>>();

      container.listen(
        routeListProvider,
        listener,
        fireImmediately: true,
      );

    });

    test('state should be initialized to empty list', () {
      container.read(routeListProvider);
      List<List<Neo4jRoute>> expectedStates = [
        []
      ];
      listener.verifyInOrder(expectedStates);
    });
    test('calculateRouteMetricTotal should return sum of `time` for all RouteEntity elements in state', () {
      // Creates a container containing all of our providers
      final container = createContainer();

      container.read(routeListProvider.notifier).state = [aToB, aToBFlight, bToA];

      double totalTime = container.read(routeListProvider.notifier).calculateRouteMetricTotal(RouteMetric.TIME);

      expect(totalTime, equals(10.6));
    });

    test('calculateRouteMetricTotal should return sum of `popularity` for all RouteEntity elements in state', () {
      // Creates a container containing all of our providers
      final container = createContainer();

      container.read(routeListProvider.notifier).state = [aToB, aToBFlight, bToA];

      double totalPopularity = container.read(routeListProvider.notifier).calculateRouteMetricTotal(RouteMetric.POPULARITY);

      expect(totalPopularity, equals(11.0));
    });
  });

}