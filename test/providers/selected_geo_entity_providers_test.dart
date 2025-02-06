import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/domain/geo_entity.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/domain/transport_type.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';

import '../riverpod_provider_container.dart';
import '../riverpod_state_listeners.dart';

void main() {

  Map<CityCriteria, double> cityMetrics = {
    CityCriteria.SAILING: 8.0,
    CityCriteria.FOOD: 4.6,
    CityCriteria.NIGHTLIFE: 10.0
  };
  Country country0 = Country("0", 'Country0', 'Some country');
  City cityA = City("", "CityA", "", cityMetrics, [], country0);
  City cityB = City("", "CityB", "", cityMetrics, [], country0);
  RouteEntity aToB = RouteEntity("", 4.0, 3.2, TransportType.BUS, cityB);


  group('GeoEntitySelectedTemplate', () {
    late ProviderContainer container;
    late StateListener<GeoEntity?> geoEntitySelectedListener;
    final geoEntitySelectedProvider = NotifierProvider<GeoEntitySelectedTemplate<GeoEntity>, GeoEntity?>(GeoEntitySelected.new);

    setUp(() {
      // Creates a container containing all of our providers
      container = createContainer();

      geoEntitySelectedListener = StateListener<GeoEntity?>();

      container.listen<GeoEntity?>(
        geoEntitySelectedProvider,
        geoEntitySelectedListener,
        fireImmediately: true,
      );

    });

    test('state should be initialized to null', () {
     container.read(geoEntitySelectedProvider);

     geoEntitySelectedListener.verifyInOrder([null]);

    });
    test('setGeoEntity() should set the state to the geoEntity passed in', () {

      container.read(geoEntitySelectedProvider.notifier).setGeoEntity(country0);
      container.read(geoEntitySelectedProvider.notifier).setGeoEntity(cityA);

      geoEntitySelectedListener.verifyInOrder([
        null,
        country0,
        cityA
      ]);
    });
    test('setGeoEntity() should reset routeListProvider state when country passed via setCountry', () {
      container.read(routeListProvider.notifier).state = [aToB];

      final routeListListener = StateListener<List<RouteEntity>>();

      container.listen(
        routeListProvider,
        routeListListener,
        fireImmediately: true,
      );

      container.read(geoEntitySelectedProvider.notifier).setGeoEntity(country0);
      container.read(routeListProvider);

      geoEntitySelectedListener.verifyInOrder([
        null,
        country0
      ]);

      routeListListener.verifyInOrder([
        [aToB],
        []
      ]);
    });
  });

  group('originCountrySelectedProvider', () {

    test('setGeoEntity() should reset originCitySelectedProvider & routeListProvider state when country passed via setCountry', () {
      final container = createContainer();

      container.read(originCitySelectedProvider.notifier).state = cityA;
      container.read(routeListProvider.notifier).state = [aToB];

      final originCountrySelectedListener = StateListener<Country?>();
      final originCitySelectedListener = StateListener<City?>();
      final routeListListener = StateListener<List<RouteEntity>>();

      container.listen<Country?>(
        originCountrySelectedProvider,
        originCountrySelectedListener,
        fireImmediately: true,
      );
      container.listen<City?>(
        originCitySelectedProvider,
        originCitySelectedListener,
        fireImmediately: true,
      );
      container.listen(
        routeListProvider,
        routeListListener,
        fireImmediately: true,
      );

      container.read(originCountrySelectedProvider.notifier).setGeoEntity(country0);
      container.read(originCitySelectedProvider);
      container.read(routeListProvider);

      originCountrySelectedListener.verifyInOrder([
        null,
        country0
      ]);

      originCitySelectedListener.verifyInOrder([
        cityA,
        null
      ]);

      routeListListener.verifyInOrder([
        [aToB],
        []
      ]);


    });
  });

}