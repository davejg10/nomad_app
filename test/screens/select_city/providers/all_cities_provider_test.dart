import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
import 'package:nomad/providers/selected_country_provider.dart';
import 'package:nomad/screens/select_city/providers/all_cities_provider.dart';

import '../../../riverpod_provider_container.dart';

class MockUserRepository extends Mock implements DestinationRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  late Listener listener;
  late ProviderContainer container;

  int countryId = 0;

  Country testCountry = Country(countryId, 'Country0', '');

  List<City> _allCities = List.generate(4, (index) {
    return City(index, 'Country$index', '', countryId);
  });

  final destinationRepository = MockUserRepository();

  setUp(() {
    when(() => destinationRepository.getCitiesGivenCountry(countryId)).thenReturn(_allCities);

    container = createContainer(
        overrides: [
          destinationRepositoryProvider.overrideWithValue(destinationRepository)
        ]
    );

    listener = Listener<List<City>>();

    container.listen(
      allCitiesProvider,
      listener,
      fireImmediately: true,
    );
  });

  test('allCitiesProvider state should be a list of all the cities for the country stored in selectedCountryProvider', () {
    container.read(selectedCountryProvider.notifier).setCountry(testCountry);
    verifyInOrder([
        () => listener(null, []),
        () => listener([], _allCities)
    ]);

  });

  test('if the country in selectedCountryProvider changes then allCitiesProvider state should dynamically be updated to reflect these new cities', () {
    int secondCountryId = 1;
    Country secondCountry = Country(secondCountryId, 'Country2', '');
    List<City> secondCountryCities = List.generate(4, (index) {
      return City(index, 'Country$index', '', secondCountryId);
    });
    when(() => destinationRepository.getCitiesGivenCountry(secondCountryId)).thenReturn(secondCountryCities);

    container.read(selectedCountryProvider.notifier).setCountry(testCountry);
    container.read(allCitiesProvider);
    container.read(selectedCountryProvider.notifier).setCountry(secondCountry);
    container.read(allCitiesProvider);

    verifyInOrder([
      () => listener(null, []),
      () => listener([], _allCities),
      () => listener(_allCities, secondCountryCities)
    ]);

  });
}