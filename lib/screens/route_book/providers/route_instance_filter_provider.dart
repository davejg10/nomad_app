import 'package:flutter_riverpod/flutter_riverpod.dart';

final routeInstanceSortOptionProvider = NotifierProvider<RouteInstanceSortOptionNotifier, String>(RouteInstanceSortOptionNotifier.new);

class RouteInstanceSortOptionNotifier extends Notifier<String> {

  @override
  String build() {
    return 'Price: Low to High';
  }

  void setSortOption(String sortOption) {
    state = sortOption;
  }
}