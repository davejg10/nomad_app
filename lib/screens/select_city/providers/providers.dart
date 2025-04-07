import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/generic_queried_list_providers.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_controller_provider.dart';

import '../../../domain/neo4j/neo4j_city.dart';

final lastCitySelectedProvider = NotifierProvider<GeoEntitySelectedTemplate<Neo4jCity>, Neo4jCity?>(LastCitySelected.new);

class LastCitySelected extends GeoEntitySelectedTemplate<Neo4jCity> {

  @override
  void setGeoEntity(Neo4jCity selectedCity) {
    state = selectedCity;
  }
}

final availableCityQueriedListProvider = cityQueriedListTemplate(availableCityListControllerProvider);
