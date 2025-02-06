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
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_controller_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_provider.dart';

import '../../../riverpod_provider_container.dart';

class MockBackendRepository extends Mock implements BackendRepository {}
class MockAvailableCityListNotifier extends AsyncNotifier<Set<City>> with Mock implements AvailableCityListNotifier {}



void main() {
  late ProviderContainer container;

  String countryId = "ffff8";
  String cityId = "cityid";

  Country country = Country(countryId, 'Country0', '');

  Map<CityCriteria, double> cityMetrics = {
    CityCriteria.SAILING: 8.0,
    CityCriteria.FOOD: 4.6,
    CityCriteria.NIGHTLIFE: 10.0
  };

  City fetchedCity = City(
      cityId, "CityA", "", cityMetrics, [], country);

  final backendRepository = MockBackendRepository();


  group('_routeChangedTriggerProvider', () {
    late MockAvailableCityListNotifier mockAvailableCityListProvider;
    setUp(() {
      mockAvailableCityListProvider = MockAvailableCityListNotifier();

      when(() =>
          backendRepository.findByIdFetchRoutesByCountryId(cityId, countryId))
          .thenAnswer((_) async => fetchedCity);

      container = createContainer(
          overrides: [
            backendRepositoryProvider.overrideWithValue(
                backendRepository),
            availableCityListProvider.overrideWith(() => mockAvailableCityListProvider)
          ]
      );
    });

    test('if routeListProvider next state is not empty, calls availableCityListProvider.fetchAllNextCities(cityId, countryId), where cityId is the ID of the last element in routeListProvider and countryId is the id of the country stored in destinationCountrySelectedProvider', () async {

      container.read(destinationCountrySelectedProvider.notifier).setGeoEntity(country);
      RouteEntity routeToCityFetchedCity = RouteEntity("", 4.0, 3.2, TransportType.FLIGHT, fetchedCity);
      await container.read(availableCityListControllerProvider); // This registers the _routeChangedTriggerProvider

      container.read(routeListProvider.notifier).addToItinerary(routeToCityFetchedCity);

      verify(() => mockAvailableCityListProvider.fetchAllNextCities(fetchedCity.getId, container.read(destinationCountrySelectedProvider)!.getId)).called(1);

    });
    test('if routeListProvider next state is empty, calls availableCityListProvider.reset()', () async {

      container.read(destinationCountrySelectedProvider.notifier).setGeoEntity(country);
      RouteEntity routeToCityFetchedCity = RouteEntity("", 4.0, 3.2, TransportType.FLIGHT, fetchedCity);
      await container.read(availableCityListControllerProvider); // This registers the _routeChangedTriggerProvider

      container.read(routeListProvider.notifier).state = [routeToCityFetchedCity];
      container.read(routeListProvider.notifier).removeLastFromItinerary();

      verify(() => mockAvailableCityListProvider.reset()).called(1);
    });

  });

}
