import 'package:flutter_test/flutter_test.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/domain/transport_type.dart';


void main() {

  group('city', () {
    String id = 'The did';
    String name = 'CityName';
    String description = 'The description';
    String countryId = '1';
    double sailingMetric = 4.666;
    double foodMetric = 8.044444;
    double nightlifeMetric = 10;
    String? cityCountry = null;

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

    Map<CityCriteria, double> cityMetrics = {
      CityCriteria.SAILING: double.parse((sailingMetric).toStringAsFixed(2)),
      CityCriteria.FOOD: double.parse((foodMetric).toStringAsFixed(2)),
      CityCriteria.NIGHTLIFE: double.parse((nightlifeMetric).toStringAsFixed(2))
    };
    Map<CityCriteria, double> targetCityMetrics = {
      CityCriteria.SAILING: double.parse((targetCitySailingMetric).toStringAsFixed(2)),
      CityCriteria.FOOD: double.parse((targetCityFoodMetric).toStringAsFixed(2)),
      CityCriteria.NIGHTLIFE: double.parse((targetCityNightlifeMetric).toStringAsFixed(2))
    };

    Map<String, dynamic> json = {
      'id': id,
      'name': name,
      'description': description,
      'cityMetrics': "{\"sailing\":{\"criteria\":\"SAILING\",\"metric\":$sailingMetric},\"food\":{\"criteria\":\"FOOD\",\"metric\":$foodMetric},\"nightlife\":{\"criteria\":\"NIGHTLIFE\",\"metric\":$nightlifeMetric}}",
      'country': cityCountry,
      'routes': [
        {
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
        },
      ]
    };

    test('literalFromJson should return a a city with id, name, descriptipn, cityMetrics, empty routes and countryId', () {

      City citified = City.literalFromJson(json);
      expect(citified, equals(City(id, name, description, cityMetrics, [], '0')));
    });
    test('fromJson should return a a city with id, name, descriptipn, cityMetrics, routes and countryId', () {

      City citified = City.fromJson(json);
      City targetCity = City(targetCityId, targetCityName, targetCityDescription, targetCityMetrics, targetCityRoutes, '0');
      RouteEntity route = RouteEntity(routeId, popularity, time, transportType, targetCity);
      expect(citified, equals(City(id, name, description, cityMetrics, [route], '0')));
    });

    test('fetchRoutesForGivenCity(id) should return all routes where the target city has has passed id', () {
      Map<CityCriteria, double> cityMetrics = {
        CityCriteria.SAILING: 8.0,
        CityCriteria.FOOD: 4.6,
        CityCriteria.NIGHTLIFE: 10.0
      };
      City cityA = City('cityAID', 'cityA', '', cityMetrics, [], '0');
      City cityB = City('cityBID', 'cityB', '', cityMetrics, [], '0');

      RouteEntity routeToABUS = RouteEntity(routeId, popularity, time, TransportType.BUS, cityA);
      RouteEntity routeToAFLIGHT = RouteEntity(routeId, popularity, time, TransportType.FLIGHT, cityA);
      RouteEntity route = RouteEntity(routeId, popularity, time, transportType, cityB);
      City originCity = City('originId', 'origin', '', cityMetrics, [routeToABUS, routeToAFLIGHT, route], '0');

      expect(originCity.getRoutes.length, equals(3));
      expect(originCity.fetchRoutesForGivenCity(cityA.getId).length, equals(2));
      expect(originCity.fetchRoutesForGivenCity(cityA.getId), equals(Set.of({routeToABUS, routeToAFLIGHT})));
    });

    test('fetchRoutesForGivenCity(id) should return empty Set when there are no routes where the target city has has passed id', () {
      Map<CityCriteria, double> cityMetrics = {
        CityCriteria.SAILING: 8.0,
        CityCriteria.FOOD: 4.6,
        CityCriteria.NIGHTLIFE: 10.0
      };
      City cityA = City('cityAID', 'cityA', '', cityMetrics, [], '0');

      City cityB = City('cityBID', 'cityB', '', cityMetrics, [], '0');

      RouteEntity route = RouteEntity(routeId, popularity, time, transportType, cityB);
      City originCity = City('originId', 'origin', '', cityMetrics, [route], '0');

      expect(originCity.getRoutes.length, equals(1));
      expect(originCity.fetchRoutesForGivenCity(cityA.getId).length, equals(0));
    });

  });

}