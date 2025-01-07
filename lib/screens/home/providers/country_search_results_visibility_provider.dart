import 'package:flutter_riverpod/flutter_riverpod.dart';

final countrySearchResultsVisibilityProvider = NotifierProvider<CountrySearchResultsVisibility, bool>(CountrySearchResultsVisibility.new);

class CountrySearchResultsVisibility extends Notifier<bool> {

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