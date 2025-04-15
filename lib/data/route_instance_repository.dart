import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/sql/route_instance.dart';

class RouteInstanceRepository {
  static Logger _logger = Logger(printer: CustomLogPrinter('route_instance_repository.dart'));

  http.Client httpClient;
  String backendUri;

  RouteInstanceRepository(this.httpClient, this.backendUri);

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
        _logger.i('${response.statusCode} - [Response]: ${response.body}');
        List<dynamic> routeInstances = jsonDecode(response.body);
        Set<RouteInstance> deserializedRouteInstances = {};
        for (Map<String, dynamic> routeInstance in routeInstances) {
          deserializedRouteInstances.add(RouteInstance.fromJson(routeInstance));
        }
        return deserializedRouteInstances;
      case 202:
        _logger.w('${response.statusCode} - [Response]: ${response.body}');
        int delay = (5 * 1000); // Exponential Backoff

        _logger.i("Data not ready, retrying in ${delay / 1000} seconds...");
        await Future.delayed(Duration(milliseconds: delay));

        if (retryCount < 5) { // Prevent infinite retries
          Set<RouteInstance> routeInstances = await findRouteInstancesByRouteDefinitionIdInAndSearchDate(sourceCity, targetCity, routeDefinitionIds, searchDate, retryCount: retryCount + 1);
          return routeInstances;
        } else {
          _logger.e("Gave up after 5 retries.");
          throw Exception('Attempted to retry for RouteInstances but timed-out');
        }
      case 404:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception(response.body);
      default:
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }
}