import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/providers/selected_country_provider.dart';

import '../riverpod_provider_container.dart';

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {

  group('selected country provider', () {
    test('selctedCountryProvider state should be initialized to null', () {
      // Creates a container containing all of our providers
      final container = createContainer();

      final listener = Listener<Country?>();

      container.listen<Country?>(
        selectedCountryProvider,
        listener,
        fireImmediately: true,
      ); // Calling this method on the userNotifierProvider causes the underlying UserNotifier to be initialized, since all providers are lazy-loaded.

      verify(
        // the build method returns a value immediately, so we expect AsyncData
            () => listener(null, null),
      ).called(1);

      // verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
    });
    test('selectedCountryProvider state should set state to the country passed via setCountry', () {
      final container = createContainer();

      final listener = Listener<Country?>();

      container.listen<Country?>(
        selectedCountryProvider,
        listener,
        fireImmediately: true,
      );

      verify(
            () => listener(null, null),
      ).called(1);

      Country someCountry = Country("0", 'Country0', 'Some country');

      container.read(selectedCountryProvider.notifier).setCountry(someCountry);

      verify(
            () => listener(null, someCountry),
      ).called(1);


      // verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
    });
    test('selectedCountryProvider should reset routeListProvider state when country passed via setCountry', () {
      // Creates a container containing all of our providers

      final container = createContainer();
      City someCity = City(0, 'City0', 'Some city', "0");
      Country someCountry = Country("0", 'Country0', 'Some country');

      container.read(routeListProvider.notifier).state = [someCity];

      final selectedCountryListener = Listener<Country?>();
      final selectedRouteListListener = Listener<List<City>>();

      container.listen<Country?>(
        selectedCountryProvider,
        selectedCountryListener,
        fireImmediately: true,
      );
      container.listen(
        routeListProvider,
        selectedRouteListListener,
        fireImmediately: true,
      );

      container.read(selectedCountryProvider.notifier).setCountry(someCountry);
      container.read(routeListProvider); // need to access provider otherwise listener wont be fired

      verifyInOrder([
        () => selectedCountryListener(null, null),
        () => selectedCountryListener(null, someCountry),
      ]);

      verifyInOrder([
        () => selectedRouteListListener(null, [someCity]),
        () => selectedRouteListListener([someCity], [])
      ]);

    });
  });

}