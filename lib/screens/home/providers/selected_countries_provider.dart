import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';

final selectedCountryListProvider = NotifierProvider<SelectedCountryListNotifier, Set<Neo4jCountry>>(SelectedCountryListNotifier.new);

class SelectedCountryListNotifier extends Notifier<Set<Neo4jCountry>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('selected_country_provider.dart'));

  @override
  Set<Neo4jCountry> build() {
    return {};
  }

  void setAll(Set<Neo4jCountry> selectedCountries) {
    state = selectedCountries;
  }

  void addCountry(Neo4jCountry selectedCountry) {
    state = {...state, selectedCountry};
  }

  void removeCountry(Neo4jCountry selectedCountry) {
    state = state.where((country) => country.getId != selectedCountry.getId).toSet();
  }
}
