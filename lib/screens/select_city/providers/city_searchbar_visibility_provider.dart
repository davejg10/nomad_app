import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'city_searchbar_visibility_provider.g.dart';

@riverpod
class CitySearchbarVisibility extends _$CitySearchbarVisibility {

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

