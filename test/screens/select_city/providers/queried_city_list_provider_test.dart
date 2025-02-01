import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/providers/selected_destination_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_provider.dart';
import 'package:nomad/screens/select_city/providers/queried_city_list_provider.dart';

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
    return City(index, 'City$index', '', countryId);
  });

  setUp(() {
    final destinationRepository = MockUserRepository();
    when(() => destinationRepository.getCitiesGivenCountry(countryId)).thenReturn(_allCities);

    container = createContainer(
        overrides: [
          destinationRepositoryProvider.overrideWithValue(destinationRepository)
        ]
    );

    listener = Listener<List<City>>();

    container.listen(
      queriedCityListProvider,
      listener,
      fireImmediately: true,
    );

    container.read(selectedCountryProvider.notifier).setCountry(testCountry);
  });

  test('queriedCityListProvider state should be initialized to the value of availableCityListProvider', () {

    verifyInOrder([
          () => listener(null, []),
          () => listener([], _allCities),
    ]);

    assert(container.read(availableCityListProvider) == container.read(queriedCityListProvider));
  });

  test('if queriedCityListProvider.filter is called then its state should be filtered to only contain Cities that contain the userInput', () {

    container.read(queriedCityListProvider.notifier).filter('City');
    assert(container.read(queriedCityListProvider).length == 4);

    container.read(queriedCityListProvider.notifier).filter('City0');
    assert(container.read(queriedCityListProvider).length == 1);

    container.read(queriedCityListProvider.notifier).filter('');
    assert(container.read(queriedCityListProvider).length == container.read(availableCityListProvider).length);
  });

  test('queriedCityListProvider state should re-initialize to availabilityCityListProvider state whenever availabilityCityListProvider state changes', () {

    container.read(queriedCityListProvider.notifier).filter('City0');
    assert(container.read(queriedCityListProvider).length == 1);

    City cityToAddToItinerary = _allCities[2];
    container.read(routeListProvider.notifier).addToItinerary(cityToAddToItinerary);

    assert(container.read(queriedCityListProvider).length == container.read(availableCityListProvider).length);
    assert(!container.read(queriedCityListProvider).contains(cityToAddToItinerary));

  });

}