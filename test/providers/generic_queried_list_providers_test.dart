
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad/data/backend_respository.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/domain/geo_entity.dart';
import 'package:nomad/providers/generic_queried_list_providers.dart';

import '../riverpod_provider_container.dart';
import '../riverpod_state_listeners.dart';

void main() {
  late StateListener listener;
  late ProviderContainer container;
  var genericQueriedListProvider;
  var sourceProvider;
  Set<Country> _allCountries = List.generate(4, (index) {
    return Country("$index", 'Country$index', '');
  }).toSet();

  group('GenericQueriedListNotifier', () {
    setUp(() {

      sourceProvider = FutureProvider<Set<GeoEntity>>((ref) async {
        Future.delayed(Duration(seconds: 2));
        return _allCountries;
      });

      final genericQueriedListTemplate = AsyncNotifierProviderFamily<GenericQueriedListNotifier<GeoEntity>, Set<GeoEntity>, FutureProvider<Set<GeoEntity>>>(
            () => GenericQueriedListNotifier<GeoEntity>(),
      );
      genericQueriedListProvider = genericQueriedListTemplate(sourceProvider);

      container = createContainer();

      listener = StateListener<AsyncValue<Set<GeoEntity>>>();

      container.listen(
        genericQueriedListProvider,
        listener,
        fireImmediately: true,
      );

    });

    test('state should be initialized to the value of sourceProvider', () async {
      await container.read(genericQueriedListProvider);

      listener.verifyInOrderAsync([
        AsyncLoading<Set<GeoEntity>>(),
        AsyncData<Set<GeoEntity>>(_allCountries)
      ]);

      assert(container.read(sourceProvider) == container.read(genericQueriedListProvider));
    });

    test('filter() should filter state to only contain GeoEntities that contain the userInput', () async {
      await container.read(genericQueriedListProvider);

      container.read(genericQueriedListProvider.notifier).filter('Country');
      assert(container.read(genericQueriedListProvider).value!.length == _allCountries.length);

      container.read(genericQueriedListProvider.notifier).filter('Country0');
      assert(container.read(genericQueriedListProvider).value!.length == 1);

      container.read(genericQueriedListProvider.notifier).filter('');
      assert(container.read(genericQueriedListProvider).value!.length == container.read(sourceProvider).value!.length);
    });

    test('submit() should return null when sourceProvider does not contain an element == userInput, and state should remain the same', () async {
      await container.read(genericQueriedListProvider);

      GeoEntity? submittedCountry = container.read(genericQueriedListProvider.notifier).submit('invalid');

      assert(submittedCountry == null);

      listener.verifyInOrderAsync([
        AsyncLoading<Set<GeoEntity>>(),
        AsyncData<Set<GeoEntity>>(_allCountries)
      ]);
    });

    test('submit() should return GeoEntity when sourceProvider contains an element == userInput, and state should remain the same', () async {
      await container.read(genericQueriedListProvider);

      Country? submittedCountry = container.read(genericQueriedListProvider.notifier).submit('Country0');

      assert(submittedCountry == _allCountries.elementAt(0));

      listener.verifyInOrderAsync([
        AsyncLoading<Set<GeoEntity>>(),
        AsyncData<Set<GeoEntity>>(_allCountries)
      ]);
    });

    test('reset() should set state back to sourceProvider state', () async {
      await container.read(genericQueriedListProvider);

      container.read(genericQueriedListProvider.notifier).filter('Country0');
      assert(container.read(genericQueriedListProvider).value!.length == 1);

      container.read(genericQueriedListProvider.notifier).reset();
      assert(container.read(genericQueriedListProvider).value!.length != 1);
      assert(container.read(genericQueriedListProvider) == container.read(sourceProvider));
    });
  });




}