import 'package:flutter_riverpod/flutter_riverpod.dart';

final citySearchbarVisibilityProvider = NotifierProvider<CitySearchbarVisibility, bool>(CitySearchbarVisibility.new);

class CitySearchbarVisibility extends Notifier<bool> {

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