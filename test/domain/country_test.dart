
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad/domain/country.dart';

import '../test_data.dart';

void main() {
  group('country', () {


    test(
        'fromJson should return a country with id, name, description', () {
          Country countrified = Country.fromJson(TestData.countryJson);
          expect(countrified, TestData.country);
    });

  });

}