import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/domain/sql/sql_city.dart';

import '../custom_log_printer.dart';
import '../domain/city_criteria.dart';
import '../domain/neo4j/neo4j_city.dart';
import '../domain/neo4j/neo4j_route.dart';

class CityRepository {
  static Logger _logger = Logger(printer: CustomLogPrinter('city_repository.dart'));

  http.Client httpClient;
  String backendUri;

  CityRepository(this.httpClient, this.backendUri);

  Future<Set<Neo4jCity>> findByIdFetchRoutesByTargetCityCountryId(String countryId) async {
    _logger.i("Fetching cities given country with id $countryId");
    final response = await httpClient.get(Uri.parse(backendUri + '/neo4jCountries/$countryId/cities'));

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Response]: Of some cities');
        List<dynamic> fetchedCities = jsonDecode(response.body);
        Set<Neo4jCity> allCities = {};
        for (var city in fetchedCities) {
          allCities.add(Neo4jCity.fromJson(city));
        }
        return allCities;
      case 404:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception(response.body);
      default:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }

  Future<Set<Neo4jCity>> fetchCitiesByCountryIdsOrderByPreferences(Set<Neo4jCountry> selectedCountryList, Map<CityCriteria, int> cityCriteriaPreferences, int costPreference) async {
    Set<String> selectedCountriesIds = selectedCountryList.map((country) => country.getId).toSet();
    Set<String> selectedCountriesNames = selectedCountryList.map((country) => country.getName).toSet();

    _logger.i("Fetching all Neo4jCities that exist in the following countries; $selectedCountriesNames, ordering by preference");
    final Uri url = Uri.parse(backendUri + '/neo4jCities/routes/preferences')
        .replace(queryParameters: {
      "selectedCountryIds": selectedCountriesIds.join(','),
      ...cityCriteriaPreferences.map((key, value) => MapEntry(key.name, value.toString())),
      "costPreference": costPreference.toString()
    });
    final response = await httpClient.get(url);

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Response]: ${response.body}');
        List<dynamic> neo4jCities = jsonDecode(response.body);
        Set<Neo4jCity> deserializedCities = {};
        for (Map<String, dynamic> city in neo4jCities) {
          deserializedCities.add(Neo4jCity.fromCityInfoDTO(city));
        }
        return deserializedCities;
      case 404:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception(response.body);
      default:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }

  Future<Set<Neo4jRoute>> fetchRoutesByTargetCityCountryIdsOrderByPreferences(String cityId, Set<Neo4jCountry> selectedCountryList, Map<CityCriteria, int> cityCriteriaPreferences, int costPreference) async {
    Set<String> selectedCountriesIds = selectedCountryList.map((country) => country.getId).toSet();
    Set<String> selectedCountriesNames = selectedCountryList.map((country) => country.getName).toSet();

    _logger.i("Fetching city with id $cityId and all routes with to cities in the following countries; $selectedCountriesNames, ordering by preference");
    final Uri url = Uri.parse(backendUri + '/neo4jCities/$cityId/routes/preferences')
        .replace(queryParameters: {
      "selectedCountryIds": selectedCountriesIds.join(','),
      ...cityCriteriaPreferences.map((key, value) => MapEntry(key.name, value.toString())),
      "costPreference": costPreference.toString()
    });
    final response = await httpClient.get(url);

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Response]: ${response.body}');
        List<dynamic> neo4jRoutes = jsonDecode(response.body);
        Set<Neo4jRoute> deserializedRoutes = {};
        for (Map<String, dynamic> route in neo4jRoutes) {
          deserializedRoutes.add(Neo4jRoute.fromRouteInfoDTO(route));
        }
        return deserializedRoutes;
      case 404:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception(response.body);
      default:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }

  Future<SqlCity> findSqlCityById(String id) async {
    _logger.i("Fetching SqlCity with id $id");
    final response = await httpClient.get(Uri.parse(backendUri + '/sqlCities/$id'));

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Response]: ${response.body}');
        dynamic fetchedCity = jsonDecode(response.body);
        SqlCity sqlCity = SqlCity.fromJson(fetchedCity);
        return sqlCity;
      case 404:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception(response.body);
      default:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }

}