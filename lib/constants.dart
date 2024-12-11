import 'domain/city.dart';
import 'domain/country.dart';
import 'dart:math';

final List<Country> allCountries = List.generate(100, (index) {
  return Country(index, 'Country$index', 'some random crap');
});

Random random = Random();
final List<City> allCities = List.generate(500, (index) {
  return City(index, 'City$index', 'some city description', random.nextInt(100 + 1));
});



