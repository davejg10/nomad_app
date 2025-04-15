import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/city_repository.dart';
import 'package:nomad/domain/neo4j_city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j_country.dart';
import 'package:nomad/domain/geo_entity.dart';
import 'package:nomad/providers/repository_providers.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/home/providers/all_origin_cities_provider.dart';

import '../../../riverpod_provider_container.dart';
import '../../../riverpod_state_listeners.dart';

class MockBackendRepository extends Mock implements BackendRepository {}



void main() {
  late StateListener listener;
  late ProviderContainer container;

  String countryId = 'fff88';
  Country country = Country(countryId, 'Country0', '');
  Map<CityCriteria, double> cityMetrics = {
    CityCriteria.SAILING: 8.0,
    CityCriteria.FOOD: 4.6,
    CityCriteria.NIGHTLIFE: 10.0
  };
  Set<City> _allCities = List.generate(4, (index) {
    return City("$index", 'City$index', '', cityMetrics, [], country);
  }).toSet();

  final backendRepository = MockBackendRepository();

  group('allOriginCitiesProvider', () {
    setUp(() {
      when(() => backendRepository.getCitiesGivenCountry(countryId)).thenAnswer((_) async => _allCities);

      container = createContainer(
          overrides: [
            backendRepositoryProvider.overrideWithValue(backendRepository)
          ]
      );

      listener = StateListener<AsyncValue<Set<City>>>();

      container.listen(
        allOriginCitiesProvider,
        listener,
        fireImmediately: true,
      );
    });

    test('state should be initialized to an empty set', () {
      container.read(allOriginCitiesProvider);
      List<AsyncValue<Set<City>>> expectedStates = [const AsyncData<Set<City>>({})];

      listener.verifyInOrderAsync(expectedStates);
    });

    test('when originCountrySelectedProvider state is initailzied then state should reactively be set to all cities for the country stored in originCountrySelectedProvider', () async {

      container.read(originCountrySelectedProvider.notifier).setGeoEntity(country);
      await container.read(allOriginCitiesProvider);

      List<AsyncValue<Set<City>>> expectedStates = [
        const AsyncData<Set<City>>({}),
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(_allCities)
      ];

      listener.verifyInOrderAsync(expectedStates);

    });

    test('if the country in originCountrySelectedProvider changes then allOriginCitiesProvider state should dynamically be updated to reflect these new cities', () async {
      String secondCountryId = "sfsdsa";
      Country secondCountry = Country(secondCountryId, 'Country2', '');
      Set<City> secondCountryCities = List.generate(4, (index) {
        return City("$index", 'City$index', '', cityMetrics, [], secondCountry);
      }).toSet();
      when(() => backendRepository.getCitiesGivenCountry(secondCountryId)).thenAnswer((_) async => secondCountryCities);

      container.read(originCountrySelectedProvider.notifier).setGeoEntity(country);
      await container.read(allOriginCitiesProvider);
      container.read(originCountrySelectedProvider.notifier).setGeoEntity(secondCountry);
      await container.read(allOriginCitiesProvider);

      List<AsyncValue<Set<City>>> expectedStates = [
        const AsyncData<Set<City>>({}),
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(_allCities),
        AsyncLoading<Set<City>>(),
        AsyncData<Set<City>>(secondCountryCities)
      ];

      listener.verifyInOrderAsync(expectedStates);
    });
  });


}