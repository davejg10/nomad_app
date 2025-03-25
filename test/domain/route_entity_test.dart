import 'package:flutter_test/flutter_test.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';

import '../test_data.dart';

void main() {
  group('routeEntity', () {

    test(
        'literalFromJson should return a a city with id, name, descriptipn, cityMetrics, empty routes and countryId', () {
      Neo4jRoute routified = Neo4jRoute.fromJson(TestData.routeJson);

      expect(routified, equals(TestData.routeToTarget));
    });

  });

}