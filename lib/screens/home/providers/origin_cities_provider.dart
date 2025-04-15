import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/providers/repository_providers.dart';
import 'package:nomad/providers/travel_preference_provider.dart';
import 'package:nomad/screens/home/providers/selected_countries_provider.dart';

final originCitiesProvider = FutureProvider<Set<Neo4jCity>>((ref) async {
  Set<Neo4jCountry> selectedCountries = ref.read(selectedCountryListProvider);
  Map<CityCriteria, int> cityCriteriaPreferences = {};
  for(CityCriteria criteria in CityCriteria.values) {
    cityCriteriaPreferences[criteria] = ref.read(travelPreferenceProvider(criteria.name));
  }
  int costPreference = ref.read(travelPreferenceProvider('COST'));
  return ref.read(cityRepositoryProvider).fetchCitiesByCountryIdsOrderByPreferences(selectedCountries, cityCriteriaPreferences, costPreference);
});