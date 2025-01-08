import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
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
    return Country(index, 'Country$index', '');
  });

  setUp(() {
    final destinationRepository = MockUserRepository();
    when(() => destinationRepository.getCountries()).thenReturn(_allCountries);

    container = createContainer(
      overrides: [
        destinationRepositoryProvider.overrideWithValue(destinationRepository)
      ]
    );

    listener = Listener<List<Country>>();

    container.listen(
      queriedCountryListProvider,
      listener,
      fireImmediately: true,
    );

  });

  test('queriedCountryListProvider state should be initialized to the value of allCountriesProvider', () {

    verify(
          () => listener(null, _allCountries),
    ).called(1);

    assert(container.read(allCountriesProvider) == container.read(queriedCountryListProvider));
  });

  test('if queriedCountryListProvider.filter is called then its state should be filtered to only contain Countries that contain the userInput', () {
    container.read(queriedCountryListProvider.notifier).filter('Country');
    assert(container.read(queriedCountryListProvider).length == 4);

    container.read(queriedCountryListProvider.notifier).filter('Country0');
    assert(container.read(queriedCountryListProvider).length == 1);

    container.read(queriedCountryListProvider.notifier).filter('');
    assert(container.read(queriedCountryListProvider).length == container.read(allCountriesProvider).length);
  });

  test('if queriedCountryListProvider.reset is called then its state should be set back to allCountriesProvider state', () {

    container.read(queriedCountryListProvider.notifier).filter('Country0');
    assert(container.read(queriedCountryListProvider).length == 1);

    container.read(queriedCountryListProvider.notifier).reset();
    assert(container.read(queriedCountryListProvider).length != 1);
    assert(container.read(queriedCountryListProvider) == container.read(allCountriesProvider));
  });



}