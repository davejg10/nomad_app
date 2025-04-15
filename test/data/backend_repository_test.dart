import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/city_repository.dart';
import 'package:nomad/domain/neo4j_country.dart';

import '../test_data.dart';

// Generate a MockClient using the Mocktail package.
class MockClient extends Mock implements http.Client {}
// Generate fake uri return for http.get & http.post methods
class MockUri extends Mock implements Uri {}


void main() {
  // This is required if using mocktail; https://pub.dev/packages/mocktail#how-it-works
  setUpAll(() {
    registerFallbackValue(MockUri());
  });

  group('backendRepository', () {
    final client = MockClient();
    BackendRepository backendRepository = BackendRepository(client, 'somebackenduri');

    group('getCountries', () {
      Country country1 = Country('id', 'name', 'desc');
      Country country2 = Country('id2', 'name2', 'desc2');

      List<Map<String, dynamic>> responseBody = [
        {
          'id': country1.getId,
          'name': country1.getName},
        {
          'id': country2.getId,
          'name': country2.getName
        }
      ];


      test('should return a set of all countries when response code is 200', () async {

        when(() => client.get(any())
        ).thenAnswer((_) async => http.Response(jsonEncode(responseBody), 200));

        expect(await backendRepository.getCountries(), equals(Set.of({country1, country2})));
      });

      test('should throw exception with generic error message on any other response code', () async {

        when(() => client.get(any())
        ).thenAnswer((_) async => http.Response('', 400));

        expect(() => backendRepository.getCountries(),
            throwsA(predicate((e) => e is Exception && e.toString().contains('There is an issue completing that request right now.')))
        );
      });
    });

    group('getCitiesGivenCountry', () {


      test('should return a set of all cities when response code is 200', () async {

        when(() => client.get(any())
        ).thenAnswer((_) async => http.Response(jsonEncode([TestData.cityJson]), 200));

        expect(await backendRepository.getCitiesGivenCountry(TestData.city.getCountry.getId), equals(Set.of({TestData.city})));
      });

      test('should throw exception with message from response body when response code is 404', () async {

        when(() => client.get(any())
        ).thenAnswer((_) async => http.Response('some error response from the backend', 404));

        expect(() => backendRepository.getCitiesGivenCountry(TestData.city.getCountry.getId),
            throwsA(predicate((e) => e is Exception && e.toString().contains('some error response from the backend')))
        );

      });

      test('should throw exception with generic error message when response code is not 404 or 200', () async {

        when(() => client.get(any())
        ).thenAnswer((_) async => http.Response('', 400));

        expect(() => backendRepository.getCitiesGivenCountry(TestData.city.getCountry.getId),
            throwsA(predicate((e) => e is Exception && e.toString().contains('There is an issue completing that request right now.')))
        );

      });
    });

    group('findByIdFetchRoutesByCountryId', () {


      test('should return a city when response code is 200', () async {

        when(() => client.get(any())
        ).thenAnswer((_) async => http.Response(jsonEncode(TestData.cityJson), 200));

        expect(await backendRepository.findByIdFetchRoutesByCountryId(TestData.city.getId, TestData.city.getCountry.getId), equals(TestData.city));
      });

      test('should throw exception with message from response body when response code is 404', () async {

        when(() => client.get(any())
        ).thenAnswer((_) async => http.Response('some error response from the backend', 404));

        expect(() => backendRepository.findByIdFetchRoutesByCountryId(TestData.city.getId, TestData.city.getCountry.getId),
            throwsA(predicate((e) => e is Exception && e.toString().contains('some error response from the backend')))
        );

      });

      test('should throw exception with generic error message when response code is not 404 or 200', () async {

        when(() => client.get(any())
        ).thenAnswer((_) async => http.Response('', 400));

        expect(() => backendRepository.findByIdFetchRoutesByCountryId(TestData.city.getId, TestData.city.getCountry.getId),
            throwsA(predicate((e) => e is Exception && e.toString().contains('There is an issue completing that request right now.')))
        );

      });
    });
  });
}