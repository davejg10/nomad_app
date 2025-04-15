import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/city_repository.dart';
import 'package:nomad/domain/neo4j_city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j_country.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/domain/transport_type.dart';
import 'package:nomad/providers/repository_providers.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/target_cities_given_country_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_queried_list_provider.dart';

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
    return City("$index", 'City$index', '', cityMetrics, [], country);
  }).toSet();
  Neo4jRoute aTo0 = Neo4jRoute("", 4.0, 3.2, 16.0, TransportType.BUS, _allCities.elementAt(0));
  Neo4jRoute aTo1 = Neo4jRoute("", 4.0, 3.2, 15.0, TransportType.BUS, _allCities.elementAt(1));
  Neo4jRoute aTo2 = Neo4jRoute("", 4.0, 3.2, 5.0, TransportType.BUS, _allCities.elementAt(2));
  City fetchedCity = City(cityId, "CityA", "", cityMetrics, [aTo0, aTo1, aTo2], country);


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

      Neo4jRoute aTo0 = Neo4jRoute("", 4.0, 3.2, 16.0, TransportType.BUS, _allCities.elementAt(0));
      Neo4jRoute aTo1Bus = Neo4jRoute("", 4.0, 3.2, 15.0, TransportType.BUS, _allCities.elementAt(1));
      Neo4jRoute aTo1Flight = Neo4jRoute("", 4.0, 3.2, 30.0, TransportType.FLIGHT, _allCities.elementAt(1));
      City cityWithDuplicateTargets = City("someId", "CityA", "", cityMetrics, [aTo0, aTo1Bus, aTo1Flight], country);

      when(() => backendRepository.findByIdFetchRoutesByCountryId(cityWithDuplicateTargets.getId, cityWithDuplicateTargets.getCountry.getId))
          .thenAnswer((_) async => cityWithDuplicateTargets);

      container.read(originCitySelectedProvider.notifier).setGeoEntity(fetchedCity);
      container.read(destinationCountrySelectedProvider.notifier).setGeoEntity(country);
      await Future.delayed(Duration.zero); // Allows event loop to process changes

      container.read(availableCityListProvider.notifier).fetchAllNextCities(cityWithDuplicateTargets.getId, cityWithDuplicateTargets.getCountry.getId);
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

      container.read(availableCityListProvider.notifier).fetchAllNextCities(fetchedCity.getId, fetchedCity.getCountry.getId);
      await Future.delayed(Duration.zero); // Allows event loop to process changes

      expect(container.read(currentCitySelectedProvider), fetchedCity);
    });

    test(
        'reset() should set the state to all cities reachable from the city in `originCitySelectedProvider` within the country in `desintationCountrySelectedProvider`', () async {
      City initialCity =  City(cityId, "CityA", "", cityMetrics, [], country);
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
