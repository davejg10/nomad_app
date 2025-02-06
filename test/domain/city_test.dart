import 'package:flutter_test/flutter_test.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/domain/transport_type.dart';

import '../test_data.dart';

void main() {

  group('city', () {

    test('literalFromJson should return a a city with id, name, descriptipn, cityMetrics, empty routes and countryId', () {

      City citified = City.literalFromJson(TestData.cityJson);
      expect(citified, equals(City(TestData.city.getId, TestData.city.getName, TestData.city.getDescription, TestData.city.getCityRatings, [], TestData.city.getCountry)));
    });
    test('fromJson should return a a city with id, name, descriptipn, cityMetrics, routes and countryId', () {

      City citified = City.fromJson(TestData.cityJson);

      expect(citified, equals(TestData.city));
    });

    test('fetchRoutesForGivenCity(id) should return all routes where the target city has passed id', () {

      City cityA = City('cityAID', 'cityA', '', TestData.cityMetrics, [], TestData.country);
      City cityB = City('cityBID', 'cityB', '', TestData.cityMetrics, [], TestData.country);

      RouteEntity routeToABUS = RouteEntity('1', 4.0, 3.2, TransportType.BUS, cityA);
      RouteEntity routeToAFLIGHT = RouteEntity('2', 4.5, 5, TransportType.FLIGHT, cityA);
      RouteEntity route = RouteEntity('3', 8, 4.3, TransportType.BUS, cityB);
      City originCity = City('originId', 'origin', '', TestData.cityMetrics, [routeToABUS, routeToAFLIGHT, route], TestData.country);

      expect(originCity.getRoutes.length, equals(3));
      expect(originCity.fetchRoutesForGivenCity(cityA.getId).length, equals(2));
      expect(originCity.fetchRoutesForGivenCity(cityA.getId), equals(Set.of({routeToABUS, routeToAFLIGHT})));
    });

    test('fetchRoutesForGivenCity(id) should return empty Set when there are no routes where the target city has has passed id', () {

      City cityA = City('cityAID', 'cityA', '', TestData.cityMetrics, [], TestData.country);

      City cityB = City('cityBID', 'cityB', '', TestData.cityMetrics, [], TestData.country);

      RouteEntity route = RouteEntity('1', 4.0, 3.2, TransportType.BUS, cityB);
      City originCity = City('originId', 'origin', '', TestData.cityMetrics, [route], TestData.country);

      expect(originCity.getRoutes.length, equals(1));
      expect(originCity.fetchRoutesForGivenCity(cityA.getId).length, equals(0));
    });

  });

}