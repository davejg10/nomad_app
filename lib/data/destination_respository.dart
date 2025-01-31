import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../custom_log_printer.dart';
import '../domain/city.dart';
import '../domain/country.dart';

class DestinationRepository {
  static Logger _logger = Logger(printer: CustomLogPrinter('destination_repository.dart'));

  http.Client httpClient;
  String backendUri;

  DestinationRepository(this.httpClient, this.backendUri);

  Future<Set<Country>> getCountries() async {
    _logger.w("Fetching all countries");
    final response = await httpClient.get(Uri.parse(backendUri + '/countries'));
    List<dynamic> fetchedCountries = jsonDecode(response.body);
    Set<Country> allCountries = {};
    for (var country in fetchedCountries) {
      allCountries.add(Country.fromJson(country));
    }
    return allCountries;
  }

  Future<Set<City>> getCitiesGivenCountry(String countryId) async {
    _logger.w("Fetching cities given country with id $countryId");
    final response = await httpClient.get(Uri.parse(backendUri + '/countries/$countryId/cities'));

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Reponse]: ${response.body}');
        List<dynamic> fetchedCities = jsonDecode(response.body);
        Set<City> allCities = {};
        for (var city in fetchedCities) {
          allCities.add(City.fromJson(city));
        }
        return allCities;
      case 404:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw Exception(response.body);
      default:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }

  Future<City> findByIdFetchRoutes(String cityId) async {
    _logger.w("Fetching city and all its routes with id: $cityId");
    final response = await httpClient.get(Uri.parse(backendUri + '/cities/$cityId?includeRoutes=true'));

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Reponse]: ${response.body}');
        Map<String, dynamic> cityAsMap = jsonDecode(response.body);
        City fetchedCity = City.fromJson(cityAsMap);
        return fetchedCity;
      case 404:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw Exception(response.body);
      default:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }


}