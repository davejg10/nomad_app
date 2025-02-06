import 'package:flutter_test/flutter_test.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/domain/transport_type.dart';

void main() {
  group('routeEntity', () {
    String routeId = 'route id';
    String targetCityId = 'targetCityId';
    String targetCityName = 'target';
    String targetCityDescription = 'desc';
    double targetCitySailingMetric = 4.36;
    double targetCityFoodMetric = 4.4;
    double targetCityNightlifeMetric = 9.8;
    double popularity = 3.444;
    double time = 3;
    TransportType transportType = TransportType.BUS;

    List<RouteEntity> targetCityRoutes = [];
    String? targetCityCountry = null;

    Map<CityCriteria, double> targetCityMetrics = {
      CityCriteria.SAILING: double.parse(
          (targetCitySailingMetric).toStringAsFixed(2)),
      CityCriteria.FOOD: double.parse(
          (targetCityFoodMetric).toStringAsFixed(2)),
      CityCriteria.NIGHTLIFE: double.parse(
          (targetCityNightlifeMetric).toStringAsFixed(2))
    };

    Map<String, dynamic> routeJson = {
      'id': routeId,
      'targetCity': {
        'id': targetCityId,
        'name': targetCityName,
        'description': targetCityDescription,
        'cityMetrics': "{\"sailing\":{\"criteria\":\"SAILING\",\"metric\":$targetCitySailingMetric},\"food\":{\"criteria\":\"FOOD\",\"metric\":$targetCityFoodMetric},\"nightlife\":{\"criteria\":\"NIGHTLIFE\",\"metric\":$targetCityNightlifeMetric}}",
        'routes': targetCityRoutes,
        'country': targetCityCountry
      },
      'popularity': popularity,
      'time': time,
      'transportType': transportType.name
    };

    test(
        'literalFromJson should return a a city with id, name, descriptipn, cityMetrics, empty routes and countryId', () {
      RouteEntity routified = RouteEntity.fromJson(routeJson);
      City targetCity = City(
          targetCityId, targetCityName, targetCityDescription,
          targetCityMetrics, targetCityRoutes, '0');
      expect(routified, equals(
          RouteEntity(routeId, double.parse(popularity.toStringAsFixed(2)), double.parse(time.toStringAsFixed(2)), transportType, targetCity)));
    });

  });

}