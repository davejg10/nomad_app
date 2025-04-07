import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomad/data/backend_respository.dart';
import 'package:nomad/domain/neo4j_country.dart';
import 'package:nomad/main.dart';
import 'package:nomad/screens/home_screen/home_screen.dart';
import 'package:nomad/screens/start_city_screen.dart';
import 'package:nomad/screens/home/widgets/country_card.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder findSearchBarTextField() {
    // Even though when run manually the cursor and keyboard open, when testing
    // you have to specify a widget to type into. This method returns the ViewContent textfield.
    // Cant just do widget.findByType(Searchbar). Weirdly this was the wrong textField.
    // See https://github.com/flutter/flutter/blob/master/packages/flutter/test/material/search_anchor_test.dart#L903

    Finder viewContentWidget = find.byWidgetPredicate((Widget widget) {
      return widget.runtimeType.toString() == '_ViewContent';
    });

    return find.descendant(
        of: viewContentWidget,
        matching: find.byType(TextField)
    );
  }

  Country validCountry = Country(1, 'Country2', 'description');
  setUpAll(() {
    DestinationRepository.setCountries([validCountry]);
  });

  group('home screen tests', () {
    testWidgets('when I search for a country that exists, I should be able to see the country card in the view', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.enterText(findSearchBarTextField(), validCountry.getName);
      await tester.pump();// Allows the widgets to be rebuild

      expect(find.byKey(ValueKey('countryCard${validCountry.getName}')), findsOneWidget);
    });
    testWidgets('when I search for a country that exists, I should be able to tap on the card and be navigated to the StartCityScreen with this country selected', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.enterText(findSearchBarTextField(), validCountry.getName);
      await tester.pump();

      final countryCard = find.byKey(ValueKey('countryCard${validCountry.getName}'));
      expect(countryCard, findsOneWidget);

      // Emulate a tap on the country card.
      await tester.tap(countryCard);

      // Trigger a frame.
      await tester.pumpAndSettle();

      expect(find.byType(StartCityScreen), findsOneWidget);
      expect(find.text(validCountry.getName.toUpperCase()), findsOneWidget);
    });
    testWidgets('when I search for a country that exists, I should be able tap enter on keyboard and be navigated to the StartCityScreen with this country selected', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.enterText(findSearchBarTextField(), validCountry.getName);
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.done); // simulates pressing enter
      await tester.pumpAndSettle();

      expect(find.byType(StartCityScreen), findsOneWidget);
      expect(find.text(validCountry.getName.toUpperCase()), findsOneWidget);
    });
    testWidgets('when I search for a country that doesnt exist no CountryCards should be displayed in the view', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // Enter text into the SearchBar
      const String country = "invalid";

      await tester.enterText(findSearchBarTextField(), country);
      await tester.pump();

      final countryCards = find.byType(CountryCard);
      final numCountryCards = tester.widgetList(countryCards).length;

      // Ensure the ListView exists in the widget tree
      expect(numCountryCards, equals(0));

      // Alternatively you can see the number of children that *would* be lazily instantiated
      // Access the ListView widget
      final listViewFinder = find.byType(ListView);
      final listView = tester.widget<ListView>(listViewFinder);

      final childCount = listView.childrenDelegate.estimatedChildCount ?? 0;
      expect(childCount, equals(0));
    });
    testWidgets('when I search for a country that doesnt exist and press enter on keyboard a error diaglogue should flash on screen and I should stay on home page', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // Enter text into the SearchBar
      const String country = "invalid";

      await tester.enterText(findSearchBarTextField(), country);
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.done); // simulates pressing enter
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('That is not a valid country in our list...'), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

}