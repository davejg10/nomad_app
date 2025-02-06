import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/backend_respository.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/domain/transport_type.dart';
import 'package:nomad/providers/backend_repository_provider.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_controller_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_provider.dart';

import '../../../riverpod_provider_container.dart';
import '../../../riverpod_state_listeners.dart';

class MockBackendRepository extends Mock implements BackendRepository {}

void main() {
  late StateListener availableCityListControllerListener;

  late StateListener availableCityListListener;
  late ProviderContainer container;

  String countryId = "ffff8";
  String cityId = "cityid";

  Country country = Country(countryId, 'Country0', '');

  Map<CityCriteria, double> cityMetrics = {
    CityCriteria.SAILING: 8.0,
    CityCriteria.FOOD: 4.6,
    CityCriteria.NIGHTLIFE: 10.0
  };

  Set<City> _allCities = List.generate(3, (index) {
    return City("$index", 'City$index', '', cityMetrics, [], countryId);
  }).toSet();
  RouteEntity aTo0 = RouteEntity(
      "", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(0));
  RouteEntity aTo1 = RouteEntity(
      "", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(1));
  RouteEntity aTo2 = RouteEntity(
      "", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(2));
  City fetchedCity = City(
      cityId, "CityA", "", cityMetrics, [aTo0, aTo1, aTo2], countryId);


  final backendRepository = MockBackendRepository();


  group('availableCityListControllerProvider', () {
    setUp(() {
      when(() =>
          backendRepository.findByIdFetchRoutesByCountryId(cityId, countryId))
          .thenAnswer((_) async => fetchedCity);


      container = createContainer(
          overrides: [
            backendRepositoryProvider.overrideWithValue(
                backendRepository)
          ]
      );

      availableCityListControllerListener = StateListener<AsyncValue<Set<City>>>();
      availableCityListListener = StateListener<AsyncValue<Set<City>>>();


      container.listen(
        availableCityListControllerProvider,
        availableCityListControllerListener,
        fireImmediately: true,
      );
      container.listen(
        availableCityListProvider,
        availableCityListListener,
        fireImmediately: true,
      );
    });

    test('state is a wrapper around state of availableCityListProvider', () async {

      List<AsyncValue<Set<City>>> expectedStates = [
        AsyncData<Set<City>>({})
      ];
      availableCityListListener.verifyInOrderAsync(expectedStates);

      List<AsyncValue<Set<City>>> expectedControllerStates = [
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>({})
      ];

      availableCityListControllerListener.verifyInOrderAsync(expectedControllerStates);
      expect(container.read(availableCityListProvider), container.read(availableCityListControllerProvider));


      // clear stateLists
      availableCityListListener.stateChanges.clear();
      availableCityListControllerListener.stateChanges.clear();

      container.read(originCitySelectedProvider.notifier).setGeoEntity(fetchedCity);
      container.read(destinationCountrySelectedProvider.notifier).setGeoEntity(country);
      await Future.delayed(Duration.zero); // Allows event loop to process changes

      expect(availableCityListListener.stateChanges, availableCityListControllerListener.stateChanges);
      expectedStates = [
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(_allCities),

      ];
      availableCityListListener.verifyInOrderAsync(expectedStates);
      expectedControllerStates = [
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(_allCities),

      ];
      availableCityListControllerListener.verifyInOrderAsync(expectedControllerStates);
      expect(container.read(availableCityListProvider), container.read(availableCityListControllerProvider));

      // clear stateLists
      availableCityListListener.stateChanges.clear();
      availableCityListControllerListener.stateChanges.clear();

      RouteEntity aTo0 = RouteEntity("", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(0));
      RouteEntity aTo1Bus = RouteEntity("", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(1));
      RouteEntity aTo1Flight = RouteEntity("", 4.0, 3.2, TransportType.FLIGHT, _allCities.elementAt(1));
      City cityToFetch = City("someId", "CityA", "", cityMetrics, [aTo0, aTo1Bus, aTo1Flight], countryId);

      when(() => backendRepository.findByIdFetchRoutesByCountryId(cityToFetch.getId, cityToFetch.getCountryId))
          .thenAnswer((_) async => cityToFetch);

      container.read(availableCityListProvider.notifier).fetchAllNextCities(cityToFetch.getId, cityToFetch.getCountryId);
      await Future.delayed(Duration.zero); // Allows event loop to process changes

      expectedStates = [
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(Set.of({aTo0.getTargetCity, aTo1Bus.getTargetCity})),

      ];
      availableCityListListener.verifyInOrderAsync(expectedStates);
      expectedControllerStates = [
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(Set.of({aTo0.getTargetCity, aTo1Bus.getTargetCity})),

      ];
      availableCityListControllerListener.verifyInOrderAsync(expectedControllerStates);
      expect(availableCityListListener.stateChanges, availableCityListControllerListener.stateChanges);

      expect(container.read(availableCityListProvider), container.read(availableCityListControllerProvider));

    });


  });

}