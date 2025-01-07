import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/destination_repository_provider.dart';
import 'package:nomad/providers/selected_country_provider.dart';

final allCitiesProvider = Provider<List<City>>((ref) {
  final selectedCountry = ref.watch(selectedCountryProvider);

  if (selectedCountry == null) {
    return [];
  }

  final destinationRepository = ref.read(destinationRepositoryProvider);
  return destinationRepository.getCitiesGivenCountry(selectedCountry.getId);
});