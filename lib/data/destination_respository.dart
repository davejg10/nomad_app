import 'dart:math';

import '../domain/city.dart';
import '../domain/country.dart';

// Mock DB data
List<Country> _allCountries = List.generate(100, (index) {
  return Country(index, 'Country$index', 'some random crap');
});
List<City> _allCities = List.generate(500, (index) {
  Random random = Random();
  return City(index, 'City$index', 'some city description', random.nextInt(100 + 1));
});

class DestinationRepository {

  DestinationRepository();

  List<Country> getCountries() {
    return _allCountries;
  }

  List<City> getCities() {
    return _allCities;
  }

  List<City> getCitiesGivenCountry(int countryId) {
    return getCities().where(((city) => city.getCountryId == countryId)).toList();
  }

  //Temporarily used for testing.
  // We will mock this repo later when we are using an actual backend.
  static setCities(List<City> testCities) {
    _allCities = testCities;
  }
  static setCountries(List<Country> testCountries) {
    _allCountries = testCountries;
  }
}