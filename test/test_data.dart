import 'package:nomad/domain/neo4j_city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j_country.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/domain/transport_type.dart';

class TestData {
  static double sailingMetric = 4.666;
  static double foodMetric = 8.044444;
  static double nightlifeMetric = 10;
  static double targetCitySailingMetric = 4.36;
  static double targetCityFoodMetric = 4.4;
  static double targetCityNightlifeMetric = 9.8;
  static double popularity = 3.444;
  static double time = 3;
  static double cost = 16.0;


  static Map<CityCriteria, double> cityMetrics = {
    CityCriteria.SAILING: double.parse((sailingMetric).toStringAsFixed(2)),
    CityCriteria.FOOD: double.parse((foodMetric).toStringAsFixed(2)),
    CityCriteria.NIGHTLIFE: double.parse((nightlifeMetric).toStringAsFixed(2))
  };
  static Map<CityCriteria, double> targetCityMetrics = {
    CityCriteria.SAILING: double.parse(
        (targetCitySailingMetric).toStringAsFixed(2)),
    CityCriteria.FOOD: double.parse(
        (targetCityFoodMetric).toStringAsFixed(2)),
    CityCriteria.NIGHTLIFE: double.parse(
        (targetCityNightlifeMetric).toStringAsFixed(2))
  };

  static Country country = Country('countryid', 'countryname', 'countrydescription');
  static City targetCity = City('targetid', 'targetname', 'targetdescription', targetCityMetrics, [], country);

  static Neo4jRoute routeToTarget = Neo4jRoute('routeid', double.parse(popularity.toStringAsFixed(2)), double.parse(time.toStringAsFixed(2)), cost, TransportType.BUS, targetCity);
  static City city = City('cityid', 'cityname', 'citydescription', cityMetrics, [routeToTarget], country);

  static Map<String, dynamic> countryJson = {
    'id': country.getId,
    'name': country.getName,
    'description': country.getDescription,
  };

  static Map<String, dynamic> routeJson = {
    'id': routeToTarget.getId,
    'targetCity': {
      'id': targetCity.getId,
      'name': targetCity.getName,
      'description': targetCity.getDescription,
      'cityMetrics': "{\"sailing\":{\"criteria\":\"SAILING\",\"metric\":$targetCitySailingMetric},\"food\":{\"criteria\":\"FOOD\",\"metric\":$targetCityFoodMetric},\"nightlife\":{\"criteria\":\"NIGHTLIFE\",\"metric\":$targetCityNightlifeMetric}}",
      'routes': targetCity.getRoutes,
      'country': countryJson,
    },
    'popularity': popularity,
    'time': time,
    'cost': cost,
    'transportType': routeToTarget.getTransportType.name
  };

  static Map<String, dynamic> cityJson = {
    'id': city.getId,
    'name': city.getName,
    'description': city.getDescription,
    'cityMetrics': "{\"sailing\":{\"criteria\":\"SAILING\",\"metric\":$sailingMetric},\"food\":{\"criteria\":\"FOOD\",\"metric\":$foodMetric},\"nightlife\":{\"criteria\":\"NIGHTLIFE\",\"metric\":$nightlifeMetric}}",
    'country': countryJson,
    'routes': [
      routeJson
    ]
  };
}