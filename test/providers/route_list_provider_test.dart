import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/route_list_provider.dart';

import '../riverpod_provider_container.dart';

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {

  group('route list provider', () {

    test('routeListProvider state should be initialized to empty list', () {
      // Creates a container containing all of our providers
      final container = createContainer();

      final listener = Listener<List<City>>();

      container.listen(
        routeListProvider,
        listener,
        fireImmediately: true,
      );

      verify(
            () => listener(null, []),
      ).called(1);

      // verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
    });

  });

}