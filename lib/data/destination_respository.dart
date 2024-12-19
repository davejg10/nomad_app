import 'dart:math';

import '../domain/city.dart';
import '../domain/country.dart';

// Mock DB data
List<Country> _allCountries = List.generate(100, (index) {
  return Country(index, 'Country$index', 'some random crap');
});
List<City> _allCities = List.generate(500, (index) {
  Random random = Random();
  return City(
      index,
      'City$index',
      'Lorem ipsum odor amet, consectetuer adipiscing elit. Fringilla id nibh dapibus quam, porttitor dignissim sagittis. Inceptos maecenas odio luctus mattis efficitur quis eros est. Leo ante nullam phasellus; pulvinar eleifend integer donec ridiculus pretium. Non facilisi sem; posuere nullam nibh ligula pellentesque. Mus nisl sem ultrices; tempor pellentesque malesuada. Torquent nostra quam sollicitudin ac fermentum sociosqu. Augue habitasse fames purus tincidunt justo porttitor placerat ut. Pulvinar posuere varius sit vivamus, justo cursus. Fames libero nulla quam curabitur blandit sed.Hac at congue lacus auctor magnis. Condimentum amet iaculis potenti fusce et diam diam pharetra dapibus. Sapien consectetur tincidunt etiam vivamus metus hendrerit felis tempor. Leo efficitur a nam blandit; massa accumsan. Pretium duis curae curabitur accumsan faucibus ex et. Viverra mauris pharetra est dapibus per nostra proin. Arcu natoque maecenas etiam dui nisi dolor sed. Porttitor curabitur suspendisse orci lobortis id rhoncus litora porttitor. Ultrices sapien sociosqu diam malesuada massa non nibh quis.Risus fringilla porta taciti diam elit duis nunc. Semper euismod nascetur egestas ullamcorper; cubilia semper convallis enim. Viverra ultricies volutpat habitant elementum sapien eget finibus. Cursus magnis nibh dapibus vehicula mollis semper nullam. Suspendisse iaculis vivamus, cras duis tempus scelerisque. Maximus platea parturient taciti pellentesque massa cubilia. Neque tempus tortor imperdiet eget nisl vitae semper.',
      random.nextInt(100 + 1));
});

// Temporary - will introduce a proper state management tool in next PR which will avoid this.
List<City> scopedCities = [];

class DestinationRepository {

  DestinationRepository();

  List<Country> getCountries() {
    return _allCountries;
  }

  List<City> getCities() {
    return _allCities;
  }

  List<City> getCitiesGivenCountry(int countryId) {
    return getCities().where((city) => city.getCountryId == countryId).toList();
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