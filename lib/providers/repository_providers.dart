import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/data/city_repository.dart';
import 'package:http/http.dart' as http;
import 'package:nomad/data/country_repository.dart';
import 'package:nomad/data/route_instance_repository.dart';

//const String backendUri = 'http://10.0.2.2:8080';
const String backendUri = 'http://192.168.4.189:8080';
// const String backendUri = 'https://web-t-dev-uks-nomad-01.azurewebsites.net/';

final countryRepositoryProvider = Provider<CountryRepository>((ref) {
  return CountryRepository(http.Client(), backendUri);
});

final cityRepositoryProvider = Provider<CityRepository>((ref) {
  return CityRepository(http.Client(), backendUri);
});

final routeInstanceRepositoryProvider = Provider<RouteInstanceRepository>((ref) {
  return RouteInstanceRepository(http.Client(), backendUri);
});


