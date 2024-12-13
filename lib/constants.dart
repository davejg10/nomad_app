import 'domain/country.dart';

final List<Country> allCountries = List.generate(100, (index) {
  return Country(index, 'Country$index', 'some random crap');
});

