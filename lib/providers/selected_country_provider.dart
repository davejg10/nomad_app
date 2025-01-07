import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_country_provider.g.dart';

@riverpod
class SelectedCountry extends _$SelectedCountry {

  @override
  Country? build() {
    return null;
  }

  void setCountry(Country selectedCountry) {
    ref.invalidate(routeListProvider); // If a new country is chosen clear routeList state
    state = selectedCountry;
  }
}