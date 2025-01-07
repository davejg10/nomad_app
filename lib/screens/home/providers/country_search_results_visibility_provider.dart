import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'country_search_results_visibility_provider.g.dart';

@riverpod
class CountrySearchResultsVisibility extends _$CountrySearchResultsVisibility {

  @override
  bool build() {
    return false;
  }

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }
}

