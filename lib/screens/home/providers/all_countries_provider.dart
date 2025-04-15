import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/providers/repository_providers.dart';


final allCountriesProvider = FutureProvider<Set<Neo4jCountry>>((ref) async {

  return ref.read(countryRepositoryProvider).findAll();
});
