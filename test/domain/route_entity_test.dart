import 'package:flutter_test/flutter_test.dart';
import 'package:nomad/domain/route_entity.dart';

import '../test_data.dart';

void main() {
  group('routeEntity', () {

    test(
        'literalFromJson should return a a city with id, name, descriptipn, cityMetrics, empty routes and countryId', () {
      RouteEntity routified = RouteEntity.fromJson(TestData.routeJson);

      expect(routified, equals(TestData.routeToTarget));
    });

  });

}