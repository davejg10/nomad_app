import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/logger_provider.dart';
import 'package:nomad/providers/route_list_provider.dart';

final selectedCountryProvider = NotifierProvider<SelectedCountry, Country?>(SelectedCountry.new);

class SelectedCountry extends Notifier<Country?> {

  @override
  Country? build() {
    ref.keepAlive(); // Keeps the state alive even when there are no listeners
    return null;
  }

  void setCountry(Country selectedCountry) {
    Logger logger = ref.read(loggerProvider("selected_country_provider.dart"));
    if (state != selectedCountry ) {
      ref.invalidate(routeListProvider);
    }

    state = selectedCountry;
    logger.i("Setting country to $state");
  }
}