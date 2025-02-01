import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
import 'package:nomad/providers/generic_queried_list_providers.dart';
import 'package:nomad/providers/selected_destination_provider.dart';
import 'package:nomad/screens/select_city/providers/next_cities_provider.dart';

final allOriginCitiesProvider = FutureProvider<Set<City>>((ref) {
  final selectedCountry = ref.watch(originCountrySelectedProvider);

  if (selectedCountry == null) {
    // Async.error("A valid country has not been selected", StackTrace.empty);
    return {};
  }

  final destinationRepository = ref.read(destinationRepositoryProvider);
  return destinationRepository.getCitiesGivenCountry(selectedCountry.getId);
});

final originCityQueriedListProvider = cityQueriedListProvider(allOriginCitiesProvider);
