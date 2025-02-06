import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/domain/route_entity.dart';
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
    City cityA = City("", "CityA", "", cityMetrics, [], country0.getId);
    City cityB = City("", "CityB", "", cityMetrics, [], country0.getId);
    RouteEntity aToB = RouteEntity("", 4.0, 3.2, TransportType.BUS, cityB);
    RouteEntity aToBFlight = RouteEntity("", 4.0, 3.2, TransportType.FLIGHT, cityB);
    RouteEntity bToA = RouteEntity("", 3.0, 4.2, TransportType.BUS, cityA);

    setUp(() {
      // Creates a container containing all of our providers
      container = createContainer();

      listener = StateListener<List<RouteEntity>>();

      container.listen(
        routeListProvider,
        listener,
        fireImmediately: true,
      );

    });

    test('state should be initialized to empty list', () {
      container.read(routeListProvider);
      List<List<RouteEntity>> expectedStates = [
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