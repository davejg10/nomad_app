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
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_provider.dart';
import 'package:nomad/screens/select_city/providers/providers.dart';

import '../../../riverpod_provider_container.dart';
import '../../../riverpod_state_listeners.dart';

class MockBackendRepository extends Mock implements BackendRepository {}

void main() {
  late StateListener listener;
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
  RouteEntity aTo0 = RouteEntity("", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(0));
  RouteEntity aTo1 = RouteEntity("", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(1));
  RouteEntity aTo2 = RouteEntity("", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(2));
  City fetchedCity = City(cityId, "CityA", "", cityMetrics, [aTo0, aTo1, aTo2], countryId);


  final backendRepository = MockBackendRepository();


  group('availableCityListProvider', () {
    setUp(() {

      when(() => backendRepository.findByIdFetchRoutesByCountryId(cityId, countryId))
          .thenAnswer((_) async => fetchedCity);


      container = createContainer(
          overrides: [
            backendRepositoryProvider.overrideWithValue(
                backendRepository)
          ]
      );

      listener = StateListener<AsyncValue<Set<City>>>();

      container.listen(
        availableCityListProvider,
        listener,
        fireImmediately: true,
      );
    });

    test(
        'state be initialized to empty set', () {
      List<AsyncValue<Set<City>>> expectedStates = [
        AsyncData<Set<City>>({})
      ];

      listener.verifyInOrderAsync(expectedStates);
    });

    test(
        'state should be set to result of repository.findByIdFetchRoutesByCountryId target cities ONLY WHEN BOTH originCitySelectedProvider && destinationCountrySelectedProvider != null', () async {

      container.read(originCitySelectedProvider.notifier).setGeoEntity(fetchedCity);
      container.read(availableCityListProvider);

      container.invalidate(originCitySelectedProvider);
      container.read(destinationCountrySelectedProvider.notifier).setGeoEntity(country);
      container.read(availableCityListProvider);

      container.invalidate(originCitySelectedProvider);
      container.read(originCitySelectedProvider.notifier).setGeoEntity(fetchedCity);
      container.read(destinationCountrySelectedProvider.notifier).setGeoEntity(country);
      await Future.delayed(Duration.zero); // Allows event loop to process changes

      List<AsyncValue<Set<City>>> expectedStates = [
        AsyncData<Set<City>>({}),
        AsyncData<Set<City>>({}),
        AsyncData<Set<City>>({}),
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(_allCities)
      ];

      listener.verifyInOrderAsync(expectedStates);

    });

    test(
        'fetchAllNextCities() should set the state to a Set of all UNIQUE cities reachable from the city returned from backendRepository.findByIdFetchRoutesByCountryId()', () async {

      RouteEntity aTo0 = RouteEntity("", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(0));
      RouteEntity aTo1Bus = RouteEntity("", 4.0, 3.2, TransportType.BUS, _allCities.elementAt(1));
      RouteEntity aTo1Flight = RouteEntity("", 4.0, 3.2, TransportType.FLIGHT, _allCities.elementAt(1));
      City cityWithDuplicateTargets = City("someId", "CityA", "", cityMetrics, [aTo0, aTo1Bus, aTo1Flight], countryId);

      when(() => backendRepository.findByIdFetchRoutesByCountryId(cityWithDuplicateTargets.getId, cityWithDuplicateTargets.getCountryId))
          .thenAnswer((_) async => cityWithDuplicateTargets);

      container.read(originCitySelectedProvider.notifier).setGeoEntity(fetchedCity);
      container.read(destinationCountrySelectedProvider.notifier).setGeoEntity(country);
      await Future.delayed(Duration.zero); // Allows event loop to process changes

      container.read(availableCityListProvider.notifier).fetchAllNextCities(cityWithDuplicateTargets.getId, cityWithDuplicateTargets.getCountryId);
      await Future.delayed(Duration.zero); // Allows event loop to process changes

      List<AsyncValue<Set<City>>> expectedStates = [
        AsyncData<Set<City>>({}),
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(_allCities),
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(Set.of({aTo0.getTargetCity, aTo1Bus.getTargetCity})),
      ];
      expect(cityWithDuplicateTargets.getRoutes.length, equals(3));
      expect(container.read(availableCityListProvider).value!.length, equals(2));

      listener.verifyInOrderAsync(expectedStates);
    });

    test('fetchAllNextCities() sets state of currentCitySelectedProvider to the city fetched from backendRepository.findByIdFetchRoutesByCountryId()', () async {
      expect(container.read(currentCitySelectedProvider), null);

      container.read(availableCityListProvider.notifier).fetchAllNextCities(fetchedCity.getId, fetchedCity.getCountryId);
      await Future.delayed(Duration.zero); // Allows event loop to process changes

      expect(container.read(currentCitySelectedProvider), fetchedCity);
    });

    test(
        'reset() should set the state to all cities reachable from the city in `originCitySelectedProvider` within the country in `desintationCountrySelectedProvider`', () async {
      City initialCity =  City(cityId, "CityA", "", cityMetrics, [], countryId);
      container.read(availableCityListProvider.notifier).state = AsyncData<Set<City>>(Set.of({initialCity}));

      container.read(originCitySelectedProvider.notifier).state = fetchedCity;
      container.read(destinationCountrySelectedProvider.notifier).state = country;
      container.read(availableCityListProvider.notifier).reset();

      await Future.delayed(Duration.zero); // Allows event loop to process changes

      List<AsyncValue<Set<City>>> expectedStates = [
        AsyncData<Set<City>>({}),
        AsyncData<Set<City>>(Set.of({fetchedCity})),
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(_allCities),
      ];

      listener.verifyInOrderAsync(expectedStates);
    });

  });


}
