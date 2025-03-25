import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/geo_entity.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/providers/route_list_provider.dart';

import '../custom_log_printer.dart';

final originCountrySelectedProvider = NotifierProvider<GeoEntitySelectedTemplate<Neo4jCountry>, Neo4jCountry?>(OriginCountrySelected.new);
final originCitySelectedProvider = NotifierProvider<GeoEntitySelectedTemplate<Neo4jCity>, Neo4jCity?>(GeoEntitySelected.new);
final destinationCountrySelectedProvider = NotifierProvider<GeoEntitySelectedTemplate<Neo4jCountry>, Neo4jCountry?>(GeoEntitySelected.new);

abstract class GeoEntitySelectedTemplate<T extends GeoEntity> extends Notifier<T?> {
  static Logger _logger = Logger(printer: CustomLogPrinter('selected_geo_entity_provider.dart'));

  @override
  T? build() {
    ref.keepAlive(); // Keeps the state alive even when there are no listeners
    return null;
  }

  void setGeoEntity(T selectedGeoEntity) {
    if (state != selectedGeoEntity) {
      ref.invalidate(routeListProvider);
    }

    state = selectedGeoEntity;
    _logger.i("Setting GeoEntity to $state");
  }
}

class GeoEntitySelected<T extends GeoEntity> extends GeoEntitySelectedTemplate<T> {}

class OriginCountrySelected extends GeoEntitySelectedTemplate<Neo4jCountry> {

  @override
  void setGeoEntity(Neo4jCountry selectedCountry) {
    if (state != selectedCountry) {
      ref.invalidate(originCitySelectedProvider);
    }
    super.setGeoEntity(selectedCountry);
  }
}