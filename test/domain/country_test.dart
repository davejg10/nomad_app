
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad/domain/country.dart';

void main() {
  group('country', () {
    String id = 'Countryid';
    String name = 'CountryName';
    String description = 'Country description';

    Map<String, dynamic> json = {
      'id': id,
      'name': name,
      'description': description,
    };

    test(
        'fromJson should return a country with id, name, description', () {
          Country countrified = Country.fromJson(json);
          expect(countrified, Country(id, name, description));
    });

  });

}