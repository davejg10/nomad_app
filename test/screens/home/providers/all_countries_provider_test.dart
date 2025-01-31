import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
import 'package:nomad/screens/home/providers/all_countries_provider.dart';

import '../../../riverpod_provider_container.dart';

class MockUserRepository extends Mock implements DestinationRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {

  test('allCountriesProvider state should be initialized to a list of all countries fetched from the destinationRepository', ()  async {
    final destinationRepository = MockUserRepository();

    List<Country> _allCountries = List.generate(4, (index) {
      return Country("$index", 'Country$index', '');
    });

    when(() => destinationRepository.getCountries()).thenAnswer((_) async => _allCountries);

    final container = createContainer(
      overrides: [
        destinationRepositoryProvider.overrideWithValue(destinationRepository)
      ]
    );

    final listener = Listener<AsyncValue<List<Country>>>();

    container.listen(
      allCountriesProvider,
      listener,
      fireImmediately: true,
    );

    await container.read(allCountriesProvider);

    verifyInOrder([
        () => listener(null, AsyncLoading<List<Country>>()),
        () => listener(AsyncLoading<List<Country>>(), AsyncData<List<Country>>(_allCountries)),
    ]);

    // verify that the listener is no longer called
    verifyNoMoreInteractions(listener);
  });
}