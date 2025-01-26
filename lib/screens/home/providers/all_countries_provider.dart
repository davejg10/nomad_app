// Although not global state this will cache the result and reduce further network requests
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/destination_repository_provider.dart';

final allCountriesProvider = Provider<List<Country>>((ref) {
  return ref.read(destinationRepositoryProvider).getCountries();
});