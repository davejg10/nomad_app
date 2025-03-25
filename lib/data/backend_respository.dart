import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';

import '../custom_log_printer.dart';
import '../domain/city_criteria.dart';
import '../domain/neo4j/neo4j_city.dart';
import '../domain/neo4j/neo4j_route.dart';

class BackendRepository {
  static Logger _logger = Logger(printer: CustomLogPrinter('destination_repository.dart'));

  http.Client httpClient;
  String backendUri;

  BackendRepository(this.httpClient, this.backendUri);

  Future<Set<Neo4jCountry>> findAll() async {
    _logger.i("Fetching all countries");
    final response = await httpClient.get(Uri.parse(backendUri + '/neo4jCountries'));

    switch (response.statusCode) {
      case 200:
        _logger.i('we do have a response: ${response.body}');
        List<dynamic> fetchedCountries = jsonDecode(response.body);
        Set<Neo4jCountry> allCountries = {};
        for (var country in fetchedCountries) {
          allCountries.add(Neo4jCountry.fromJson(country));
        }
        return allCountries;
      default:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }

  Future<Set<Neo4jCity>> findByIdFetchRoutesByTargetCityCountryId(String countryId) async {
    _logger.i("Fetching cities given country with id $countryId");
    final response = await httpClient.get(Uri.parse(backendUri + '/neo4jCountries/$countryId/cities'));

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Reponse]: Of some cities');
        List<dynamic> fetchedCities = jsonDecode(response.body);
        Set<Neo4jCity> allCities = {};
        for (var city in fetchedCities) {
          allCities.add(Neo4jCity.fromJson(city));
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

  Future<Set<Neo4jRoute>> fetchRoutesByTargetCityCountryIdOrderByPreferences(String cityId, String targetCityCountryId, Map<CityCriteria, int> cityCriteriaPreferences, int costPreference) async {
    _logger.i("Fetching city with id $cityId and all routes with targetCityCountryId $targetCityCountryId, ordering by preference");
    final Uri url = Uri.parse(backendUri + '/neo4jCities/$cityId/routes/preferences')
        .replace(queryParameters: {
      "targetCityCountryId": targetCityCountryId,
      ...cityCriteriaPreferences.map((key, value) => MapEntry(key.name, value.toString())),
      "costPreference": costPreference.toString()
    });
    final response = await httpClient.get(url);

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Reponse]: ${response.body}');
        List<dynamic> neo4jRoutes = jsonDecode(response.body);
        Set<Neo4jRoute> deserializedRoutes = {};
        for (Map<String, dynamic> route in neo4jRoutes) {
          deserializedRoutes.add(Neo4jRoute.fromJson(route));
        }
        return deserializedRoutes;
      case 404:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw Exception(response.body);
      default:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }

}