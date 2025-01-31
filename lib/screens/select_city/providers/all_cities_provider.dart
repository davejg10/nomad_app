import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
import 'package:nomad/providers/selected_country_provider.dart';
import 'package:nomad/screens/select_city/providers/next_cities_provider.dart';

final allCitiesProvider = FutureProvider<Set<City>>((ref) {
  final selectedCountry = ref.watch(selectedCountryProvider);

  if (selectedCountry == null) {
    // Async.error("A valid country has not been selected", StackTrace.empty);
    return {};
  }
  ref.read(nextCitiesListProvider);
  final destinationRepository = ref.read(destinationRepositoryProvider);
  return destinationRepository.getCitiesGivenCountry(selectedCountry.getId);
});