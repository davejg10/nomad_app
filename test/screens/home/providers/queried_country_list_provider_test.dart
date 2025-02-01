import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
import 'package:nomad/providers/selected_destination_provider.dart';
import 'package:nomad/screens/home/providers/all_countries_provider.dart';
import 'package:nomad/screens/home/providers/queried_country_list_provider.dart';

import '../../../riverpod_provider_container.dart';

class MockUserRepository extends Mock implements DestinationRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  late Listener listener;
  late ProviderContainer container;
  List<Country> _allCountries = List.generate(4, (index) {
    return Country("$index", 'Country$index', '');
  });

  setUp(() {
    final destinationRepository = MockUserRepository();
    when(() => destinationRepository.getCountries()).thenAnswer((_) async => _allCountries);

    container = createContainer(
      overrides: [
        destinationRepositoryProvider.overrideWithValue(destinationRepository)
      ]
    );

    listener = Listener<AsyncValue<List<Country>>>();

    container.listen(
      queriedCountriesListProvider,
      listener,
      fireImmediately: true,
    );

  });

  test('asyncQueriedCountryListProvider state should be initialized to the value of allCountriesProvider', () async {
    await container.read(queriedCountriesListProvider);

    verifyInOrder([
          () => listener(null, AsyncLoading<List<Country>>()),
          () => listener(AsyncLoading<List<Country>>(), AsyncData<List<Country>>(_allCountries)),
    ]);

    assert(container.read(allCountriesProvider) == container.read(queriedCountriesListProvider));
  });

  test('if asyncQueriedCountryListProvider.filter is called then its state should be filtered to only contain Countries that contain the userInput', () async {
    await container.read(queriedCountriesListProvider);

    container.read(queriedCountriesListProvider.notifier).filter('Country');
    assert(container.read(queriedCountriesListProvider).value!.length == 4);

    container.read(queriedCountriesListProvider.notifier).filter('Country0');
    assert(container.read(queriedCountriesListProvider).value!.length == 1);

    container.read(queriedCountriesListProvider.notifier).filter('');
    assert(container.read(queriedCountriesListProvider).value!.length == container.read(allCountriesProvider).value!.length);
  });

  test('if asyncQueriedCountryListProvider.submit is called with invalid userInput then it should not set selectedCountryProvider state to userInput & return null & not touch internal state', () async {
    await container.read(queriedCountriesListProvider);

    Country? submittedCountry = container.read(queriedCountriesListProvider.notifier).submit('invalid');

    assert(container.read(selectedCountryProvider) == null);
    assert(submittedCountry == null);

    verifyInOrder([
          () => listener(null, AsyncLoading<List<Country>>()),
          () => listener(AsyncLoading<List<Country>>(), AsyncData<List<Country>>(_allCountries)),
    ]);
  });

  test('if asyncQueriedCountryListProvider.submit is called with valid userInput then it should set selectedCountryProvider state to userInput & return userInput as country and not touch internal state', () async {
    await container.read(queriedCountriesListProvider);

    Country? submittedCountry = container.read(queriedCountriesListProvider.notifier).submit('Country0');

    assert(container.read(selectedCountryProvider) == _allCountries[0]);
    assert(submittedCountry == _allCountries[0]);

    verifyInOrder([
          () => listener(null, AsyncLoading<List<Country>>()),
          () => listener(AsyncLoading<List<Country>>(), AsyncData<List<Country>>(_allCountries)),
    ]);
  });

  test('if asyncQueriedCountryListProvider.reset is called then its state should be set back to allCountriesProvider state', () async {
    await container.read(queriedCountriesListProvider);

    container.read(queriedCountriesListProvider.notifier).filter('Country0');
    assert(container.read(queriedCountriesListProvider).value!.length == 1);

    container.read(queriedCountriesListProvider.notifier).reset();
    assert(container.read(queriedCountriesListProvider).value!.length != 1);
    assert(container.read(queriedCountriesListProvider) == container.read(allCountriesProvider));
  });



}