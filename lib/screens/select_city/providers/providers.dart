import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/generic_queried_list_providers.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_controller_provider.dart';



final currentCitySelectedProvider = NotifierProvider<GeoEntitySelectedTemplate<City>, City?>(CurrentCitySelected.new);

class CurrentCitySelected extends GeoEntitySelectedTemplate<City> {

  @override
  void setGeoEntity(City selectedCity) {
    state = selectedCity;
  }
}

final availableCityQueriedListProvider = cityQueriedListTemplate(availableCityListControllerProvider);
