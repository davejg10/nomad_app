import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/providers/selected_destination_provider.dart';
import 'package:nomad/screens/select_city/providers/all_cities_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_provider.dart';

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
    when(() => destinationRepository.getCitiesGivenCountry(countryId))
        .thenReturn(_allCities);

    container = createContainer(
        overrides: [
          destinationRepositoryProvider.overrideWithValue(destinationRepository)
        ]
    );

    listener = Listener<List<City>>();

    container.listen(
      availableCityListProvider,
      listener,
      fireImmediately: true,
    );
  });

  test(
      'availabilityCityListProvider state be initialized to allCitiesProvider state', () {
    container.read(selectedCountryProvider.notifier).setCountry(testCountry);

    verifyInOrder([
      () => listener(null, []),
      () => listener([], _allCities)
    ]);

    assert(container.read(availableCityListProvider) == container.read(allCitiesProvider));
  });

  test(
      'if a city is added to routeListProvider state then this city should be dynamically removed from availabilityCityListProvider state', () {
    container.read(selectedCountryProvider.notifier).setCountry(testCountry);

    City cityToAdd = _allCities[0];
    container.read(routeListProvider.notifier).addToItinerary(cityToAdd);

    verifyInOrder([
          () => listener(null, []),
          () => listener([], _allCities),
          () => listener(_allCities, _allCities.where((city) => city.getName != cityToAdd.getName))
    ]);

    assert(!container.read(availableCityListProvider).contains(cityToAdd));
  });

  test(
      'if a city is removed from routeListProvider state then this city should be dynamically added to availabilityCityListProvider state', () {
    container.read(selectedCountryProvider.notifier).setCountry(testCountry);

    City cityToRemove = _allCities[0];
    // Have to add it first to remove it
    container.read(routeListProvider.notifier).addToItinerary(cityToRemove);
    container.read(availableCityListProvider);
    assert(!container.read(availableCityListProvider).contains(cityToRemove));

    container.read(routeListProvider.notifier).removeFromItinerary(cityToRemove);
    container.read(availableCityListProvider);
    List<City> filteredCities = _allCities.where((city) => city.getName != cityToRemove.getName).toList();

    verifyInOrder([
          () => listener(null, []),
          () => listener([], filteredCities),
          () => listener(filteredCities, _allCities),
    ]);
    assert(container.read(availableCityListProvider).contains(cityToRemove));


  });
}
