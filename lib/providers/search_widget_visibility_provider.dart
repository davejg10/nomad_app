import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SearchWidgetIdentifier { ORIGIN_COUNTRY, DESTINATION_COUNTRY, ORIGIN_CITY, SELECT_CITY_SEARCHBAR }

final searchWidgetVisibility = NotifierProvider.family<SearchWidgetVisibility, bool, SearchWidgetIdentifier>(SearchWidgetVisibility.new);

class SearchWidgetVisibility extends FamilyNotifier<bool, SearchWidgetIdentifier> {

  @override
  bool build(SearchWidgetIdentifier type) {
    // passing param allows us to have 4 different instances of this provider
    return false;
  }

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }

  bool isOpen() {
    return state;
  }
}