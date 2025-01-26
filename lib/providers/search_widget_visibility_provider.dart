import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SearchVisibility { SEARCH_RESULTS, SEARCHBAR }

final searchWidgetVisibility = NotifierProvider.family<SearchWidgetVisibility, bool, SearchVisibility>(SearchWidgetVisibility.new);

class SearchWidgetVisibility extends FamilyNotifier<bool, SearchVisibility> {

  @override
  bool build(SearchVisibility type) {
    // passing param allows us to have two different instances of this provider
    // one for country_searchbar & one for city_searchbar
    return false;
  }

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }
}