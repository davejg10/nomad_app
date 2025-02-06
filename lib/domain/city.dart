import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../custom_log_printer.dart';
import 'city_criteria.dart';
import 'geo_entity.dart';
import 'route_entity.dart';


class City implements GeoEntity {
  static Logger _logger = Logger(printer: CustomLogPrinter('city.dart'));

  final IconData _icon = Icons.location_city;
  final String _id;
  final String _name;
  final String _description;
  final Map<CityCriteria, double> _cityRatings;
  final List<RouteEntity> _routes;
  final String _countryId;

  City(this._id, this._name, this._description, this._cityRatings, this._routes, this._countryId);

  factory City.literalFromJson(Map<String, dynamic> json) {
    String cityId = json['id'];
    String name = json['name'];
    String description = json['description'];

    Map<String, dynamic> cityMetrics = jsonDecode(json['cityMetrics']);
    final Map<CityCriteria, double> _cityMetrics = {};
    cityMetrics.forEach((key, value) {
      _cityMetrics[CityCriteria.values.firstWhere((e) => e.name == value['criteria'])] = double.parse((value['metric']).toStringAsFixed(2));
    });

    return City(cityId, name, description, _cityMetrics, [], "0");
  }

  factory City.fromJson(Map<String, dynamic> json) {
    City literalFromJson = City.literalFromJson(json);

    List<dynamic> routeList = json['routes'];
    List<RouteEntity> routes = [];
    routeList.forEach((route) {
      routes.add(RouteEntity.fromJson(route));
    });

    return City(literalFromJson.getId, literalFromJson.getName, literalFromJson.getDescription, literalFromJson.getCityRatings, routes, literalFromJson.getCountryId);
  }

  Set<RouteEntity> fetchRoutesForGivenCity(String cityId) {
    return _routes.where((route) => route.getTargetCity.getId == cityId).toSet();
  }

  IconData get getIcon => _icon;
  String get getId => _id;
  String get getName => _name;
  String get getDescription => _description;
  Map<CityCriteria, double> get getCityRatings => _cityRatings;
  List<RouteEntity> get getRoutes => _routes;
  String get getCountryId => _countryId;

  static IconData convertCriteriaToIcon(CityCriteria criteria) {
    switch (criteria) {
      case CityCriteria.SAILING:
        return Icons.sailing;
      case CityCriteria.FOOD:
        return Icons.restaurant;
      case CityCriteria.NIGHTLIFE:
        return Icons.local_bar;
      default:
        throw Exception('no mapping for criterian');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _countryId == other._countryId;

  @override
  int get hashCode =>
      _id.hashCode ^
      _countryId.hashCode;

  @override
  String toString() {
    return 'City{_icon: $_icon, _id: $_id, _name: $_name, _description: $_description, _cityRatings: $_cityRatings, _routes: $_routes, _countryId: $_countryId}';
  }
}