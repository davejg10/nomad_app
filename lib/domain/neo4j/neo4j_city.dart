import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/neo4j/geo_point_3d.dart';

import '../../custom_log_printer.dart';
import '../city_criteria.dart';
import '../geo_entity.dart';
import 'neo4j_country.dart';
import 'neo4j_route.dart';


class Neo4jCity implements GeoEntity {
  static Logger _logger = Logger(printer: CustomLogPrinter('neo4j_city.dart'));

  final IconData _icon = Icons.location_city;
  final String _id;
  final String _name;
  final String _shortDescription;
  final String _primaryBlobUrl;
  final GeoPoint3D _coordinates;
  final Map<CityCriteria, double> _cityMetrics;
  final Set<Neo4jRoute> _routes;
  final Neo4jCountry _country;

  Neo4jCity(this._id, this._name, this._shortDescription, this._primaryBlobUrl, this._coordinates, this._cityMetrics, this._routes, this._country);

  factory Neo4jCity.literalFromJson(Map<String, dynamic> json) {
    try {
      String cityId = json['id'];
      String name = json['name'];
      String shortDescription = json['shortDescription'];
      String primaryBlobUrl = json['primaryBlobUrl'];
      Map<String, dynamic> coordinatesJson = json['coordinate'];
      GeoPoint3D coordinates = new GeoPoint3D(coordinatesJson['x'], coordinatesJson['y'], coordinatesJson['z']);
      List<dynamic> cityMetrics = json['cityMetrics'];
      final Map<CityCriteria, double> _cityMetrics = {};
      if (cityMetrics.isNotEmpty) {
        cityMetrics.forEach((cityMetric) {
          _cityMetrics[CityCriteria.values.firstWhere((e) => e.name == cityMetric['criteria'])] = double.parse((cityMetric['metric']).toStringAsFixed(2));
        });
      }

      Map<String, dynamic> countryJson = json['country'];
      Neo4jCountry country = Neo4jCountry.fromJson(countryJson);
      return Neo4jCity(cityId, name, shortDescription, primaryBlobUrl, coordinates, _cityMetrics, {}, country);

    } catch (e, stackTrace) {
      _logger.w("An unexpected exception occured whilst trying to deserialize the Json in Neo4jCity.literalFromJson ${e.toString()}", error: e, stackTrace: stackTrace);
      throw e;
    }
  }

  factory Neo4jCity.fromJson(Map<String, dynamic> json) {
    Neo4jCity literalFromJson = Neo4jCity.literalFromJson(json);

    List<dynamic> routeList = json['routes'];
    Set<Neo4jRoute> routes = {};
    routeList.forEach((route) {
      routes.add(Neo4jRoute.fromJson(route));
    });
    return Neo4jCity(literalFromJson.getId, literalFromJson.getName, literalFromJson._shortDescription, literalFromJson._primaryBlobUrl, literalFromJson._coordinates, literalFromJson.getCityRatings, routes, literalFromJson.getCountry);
  }

  Neo4jCity withRoutes(Set<Neo4jRoute> routes) {
    return new Neo4jCity(_id, _name, _shortDescription, _primaryBlobUrl, _coordinates, _cityMetrics, routes, _country);
  }

  Set<Neo4jRoute> fetchRoutesForGivenCity(String cityId) {
    return _routes.where((route) => route.getTargetCity.getId == cityId).toSet();
  }

  IconData get getIcon => _icon;
  String get getId => _id;
  String get getName => _name;
  String get getShortDescription => _shortDescription;
  String get getPrimaryBlobUrl => _primaryBlobUrl;
  GeoPoint3D get getCoordinates => _coordinates;
  Map<CityCriteria, double> get getCityRatings => _cityMetrics;
  Set<Neo4jRoute> get getRoutes => _routes;
  Neo4jCountry get getCountry => _country;


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Neo4jCity &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _country == other._country;

  @override
  int get hashCode =>
      _id.hashCode ^
      _country.hashCode;

  @override
  String toString() {
    return 'City{_icon: $_icon, _id: $_id, _name: $_name, _shortDescription: $_shortDescription, _primaryBlobUrl: $_primaryBlobUrl, _coordinates: $_coordinates, _cityRatings: $_cityMetrics, _routes: $_routes, _country: $_country}';
  }
}