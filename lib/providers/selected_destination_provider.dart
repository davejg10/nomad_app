import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/domain/destination.dart';
import 'package:nomad/providers/route_list_provider.dart';

import '../custom_log_printer.dart';

final originCountrySelectedProvider = NotifierProvider<SelectedDestination<Country>, Country?>(SelectedDestination.new);
final originCitySelectedProvider = NotifierProvider<SelectedDestination<City>, City?>(SelectedDestination.new);
final destinationCountrySelectedProvider = NotifierProvider<SelectedDestination<Country>, Country?>(SelectedDestination.new);

class SelectedDestination<T extends Destination> extends Notifier<T?> {
  static Logger _logger = Logger(printer: CustomLogPrinter('selected_destination_provider.dart'));

  @override
  T? build() {
    ref.keepAlive(); // Keeps the state alive even when there are no listeners
    return null;
  }

  void setDestination(T selectedDestination) {
    if (state != selectedDestination) {
      ref.invalidate(routeListProvider);
    }

    state = selectedDestination;
    _logger.i("Setting destination to $state");
  }
}
