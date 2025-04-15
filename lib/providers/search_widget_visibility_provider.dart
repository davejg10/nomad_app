import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WidgetVisibilityProviderIdentifier { SELECT_CITY_SEARCHBAR, SELECT_CITY_LAST_CITY_TILE }

final widgetVisibilityProvider = NotifierProvider.family<WidgetVisibilityNotifier, bool, WidgetVisibilityProviderIdentifier>(WidgetVisibilityNotifier.new);

class WidgetVisibilityNotifier extends FamilyNotifier<bool, WidgetVisibilityProviderIdentifier> {

  @override
  bool build(WidgetVisibilityProviderIdentifier type) {
    // passing param allows us to have 4 different instances of this provider
    return false;
  }

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }

  void toggle() {
    state = !state;
  }

  bool isOpen() {
    return state;
  }
}