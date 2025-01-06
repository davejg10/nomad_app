import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/screens/city_details/city_details_screen.dart';
import 'package:nomad/screens/next_city_screen.dart';
import 'package:nomad/screens/start_city_screen.dart';
import 'package:nomad/widgets/city_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Country country = Country(0, 'Country1', 'some description');
  List<City> testCities = [
    City(0, 'City1', 'somedescription', 0),
    City(1, 'City2', 'somedesc', 0),
    City(2, 'City3', 'differentCountry', 1)
  ];
  setUpAll(() {
    DestinationRepository.setCountries([country]);
    DestinationRepository.setCities(testCities);
  });

  group('start_city_screen tests', () {
    testWidgets('when I navigate to start city screen with country that contains cities there should be a ListView of all available cities.', (tester) async {
      await tester.pumpWidget(MaterialApp(home: StartCityScreen(country: country)));
      await tester.pumpAndSettle();

      expect(find.byType(StartCityScreen), findsOneWidget);
      expect(find.text(country.getName.toUpperCase()), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      final cityCards = find.byType(CityCard);
      final numCityCards = tester.widgetList(cityCards).length;
      expect(numCityCards, equals(2));

      String cityInDifferentCountry = testCities[2].getName;
      final countryCard = find.byKey(ValueKey('cityCard$cityInDifferentCountry'));
      expect(countryCard, findsNothing);
    });
    testWidgets('when I navigate to start city screen with country that contains no cities there should be an empty ListView', (tester) async {
      DestinationRepository.setCities([]);

      await tester.pumpWidget(MaterialApp(home: StartCityScreen(country: country)));
      await tester.pumpAndSettle();

      expect(find.byType(StartCityScreen), findsOneWidget);
      expect(find.text(country.getName.toUpperCase()), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      final cityCards = find.byType(CityCard);
      final numCityCards = tester.widgetList(cityCards).length;
      expect(numCityCards, equals(0));

      // Replace test data
      DestinationRepository.setCities(testCities);
    });
    testWidgets('when I tap on one of the city cards I should be navigated to NextCityScreen', (tester) async {
      await tester.pumpWidget(MaterialApp(home: StartCityScreen(country: country)));
      await tester.pumpAndSettle();

      City startingCity = testCities[0];

      expect(find.byType(StartCityScreen), findsOneWidget);
      expect(find.text(country.getName.toUpperCase()), findsOneWidget);

      final cityCard = find.byKey(ValueKey('cityCard${startingCity.getName}'));
      expect(cityCard, findsOneWidget);

      // Emulate a tap on the country card.
      await tester.tap(cityCard);

      // Trigger a frame.
      await tester.pumpAndSettle();

      expect(find.byType(NextCityScreen), findsOneWidget);
    });
    testWidgets('when I tap on the arrow on one of the city cards I should be navigated to CityDetailsScreen', (tester) async {
      await tester.pumpWidget(MaterialApp(home: StartCityScreen(country: country)));
      await tester.pumpAndSettle();

      City startingCity = testCities[0];

      expect(find.byType(StartCityScreen), findsOneWidget);
      expect(find.text(country.getName.toUpperCase()), findsOneWidget);

      final cityCard = find.byKey(ValueKey('cityCard${startingCity.getName}'));
      expect(cityCard, findsOneWidget);

      final arrowButton =  find.descendant(
          of: cityCard,
          matching: find.byType(IconButton)
      );

      // Emulate a tap on the city card.
      await tester.tap(arrowButton);

      // Trigger a frame.
      await tester.pumpAndSettle();

      expect(find.byType(CityDetailsScreen), findsOneWidget);
      expect(find.text(startingCity.getName), findsOneWidget);
    });
  });
}