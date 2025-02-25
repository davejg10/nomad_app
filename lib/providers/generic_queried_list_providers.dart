import 'package:nomad/domain/city.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/domain/geo_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


final countryQueriedListTemplate = AsyncNotifierProviderFamily<GenericQueriedListNotifier<Country>, Set<Country>, FutureProvider<Set<Country>>>(
      () => GenericQueriedListNotifier<Country>(),
);
final cityQueriedListTemplate = AsyncNotifierProviderFamily<GenericQueriedListNotifier<City>, Set<City>, FutureProvider<Set<City>>>(
      () => GenericQueriedListNotifier<City>(),
);

class GenericQueriedListNotifier<T extends GeoEntity> extends FamilyAsyncNotifier<Set<T>, FutureProvider<Set<T>>> {
  late FutureProvider<Set<T>> _sourceProvider;

  @override
  Future<Set<T>> build(FutureProvider<Set<T>> sourceProvider) {
    _sourceProvider = sourceProvider;
    return ref.watch(sourceProvider.future); //AsyncValue so need to watch for changes
  }

  void filter(String userInput) {
    final sourceProviderState = ref.read(_sourceProvider);

    if (sourceProviderState.hasValue) {
      final sanitizedUserInput = userInput.trim().toLowerCase();
      final filteredList = sourceProviderState.value!
          .where((geoEntity) => geoEntity.getName.toLowerCase().contains(sanitizedUserInput))
          .toSet();

      state = AsyncValue.data(filteredList);
    }
  }

  T? submit(String userInput)  {
    final sanitizedUserInput = userInput.trim().toLowerCase();

    if (state.hasValue) {
      Set<T> elementsContainingInput = state.value!.where((geoEntity) =>
      geoEntity.getName.toLowerCase() == sanitizedUserInput)
          .toSet();
      if (elementsContainingInput.isNotEmpty) {
        return elementsContainingInput.first;
      } else {
        return null;
      }
    }
  }

  void reset() {
    state = ref.read(_sourceProvider);
  }
}