
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';

import '../../../providers/backend_repository_provider.dart';

final allOriginCitiesProvider = FutureProvider<Set<Neo4jCity>>((ref) {
  final selectedCountry = ref.watch(originCountrySelectedProvider);

  if (selectedCountry == null) {
    return {};
  }

  final backendRepository = ref.read(backendRepositoryProvider);
  return backendRepository.findByIdFetchRoutesByTargetCityCountryId(selectedCountry.getId);
});