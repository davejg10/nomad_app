import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/domain/sql/route_instance.dart';

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

  Future<Set<RouteInstance>> findRouteInstancesByRouteDefinitionIdInAndSearchDate(Neo4jCity sourceCity, Neo4jCity targetCity, List<String> routeDefinitionIds, DateTime searchDate, {int retryCount = 0}) async {
    _logger.i("Fetching all route instances with routeDefinitionIds: $routeDefinitionIds, and for searchDate: $searchDate");
    final Uri url = Uri.parse(backendUri + '/route-instances')
        .replace(queryParameters: {
      "sourceCityId": sourceCity.getId,
      "sourceCityName": sourceCity.getName,
      "targetCityId": targetCity.getId,
      "targetCityName": targetCity.getName,
      "routeDefinitionIds": routeDefinitionIds,
      "searchDate": DateFormat('yyyy-MM-dd').format(searchDate),
      "attempt": retryCount.toString(),
    });
    final response = await httpClient.get(url);

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Reponse]: ${response.body}');
        List<dynamic> routeInstances = jsonDecode(response.body);
        Set<RouteInstance> deserializedRouteInstances = {};
        for (Map<String, dynamic> routeInstance in routeInstances) {
          deserializedRouteInstances.add(RouteInstance.fromJson(routeInstance));
        }
        return deserializedRouteInstances;
      case 202:
        _logger.w('${response.statusCode} - [Reponse]: ${response.body}');
        int delay = (5 * 1000) * (1 << retryCount); // Exponential Backoff

        _logger.i("⏳ Data not ready, retrying in ${delay / 1000} seconds...");
        await Future.delayed(Duration(milliseconds: delay));

        if (retryCount < 5) { // Prevent infinite retries
          Set<RouteInstance> routeInstances = await findRouteInstancesByRouteDefinitionIdInAndSearchDate(sourceCity, targetCity, routeDefinitionIds, searchDate, retryCount: retryCount + 1);
          return routeInstances;
        } else {
          _logger.e("❌ Gave up after 5 retries.");
          throw Exception('Attempted to retry for RouteInstances but timed-out');
        }
      case 404:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw Exception(response.body);
      default:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }

}