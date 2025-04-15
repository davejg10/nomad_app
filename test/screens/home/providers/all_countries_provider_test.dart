import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/city_repository.dart';
import 'package:nomad/domain/neo4j_country.dart';
import 'package:nomad/providers/repository_providers.dart';
import 'package:nomad/screens/home/providers/all_countries_provider.dart';

import '../../../riverpod_provider_container.dart';
import '../../../riverpod_state_listeners.dart';

class MockBackendRepository extends Mock implements BackendRepository {}

void main() {

  group('allOriginCitiesProvider', () {
    test('state should be initialized to a list of all countries fetched from the backendRepository', ()  async {
      final backendRepository = MockBackendRepository();

      Set<Country> _allCountries = List.generate(4, (index) {
        return Country("$index", 'Country$index', '');
      }).toSet();

      when(() => backendRepository.getCountries()).thenAnswer((_) async => _allCountries);

      final container = createContainer(
          overrides: [
            backendRepositoryProvider.overrideWithValue(backendRepository)
          ]
      );

      final listener = StateListener<AsyncValue<Set<Country>>>();

      container.listen(
        allCountriesProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(allCountriesProvider);

      List<AsyncValue<Set<Country>>> expectedStates = [
        AsyncLoading<Set<Country>>(),
        AsyncData<Set<Country>>(_allCountries)
      ];

      listener.verifyInOrderAsync(expectedStates);

    });
  });


}