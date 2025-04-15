import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';

class CountryRepository {
  static Logger _logger = Logger(
      printer: CustomLogPrinter('country_repository.dart'));

  http.Client httpClient;
  String backendUri;

  CountryRepository(this.httpClient, this.backendUri);

  Future<Set<Neo4jCountry>> findAll() async {
    _logger.i("Fetching all countries");
    final response = await httpClient.get(
        Uri.parse(backendUri + '/neo4jCountries'));

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
        _logger.e('${response.statusCode} - [Response]: ${response.body}');
        throw Exception("There is an issue completing that request right now.");
    }
  }



}