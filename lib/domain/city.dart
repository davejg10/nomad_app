import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../custom_log_printer.dart';
import 'city_criteria.dart';
import 'route.dart' as Route;


class City {
  static Logger _logger = Logger(printer: CustomLogPrinter('city.dart'));

  final IconData _icon = Icons.location_city;
  final String _id;
  final String _name;
  final String _description;
  final Map<CityCriteria, int> _cityRatings;
  final List<Route.Route> _routes;
  final String _countryId;

  City(this._id, this._name, this._description, this._cityRatings, this._routes, this._countryId);

  factory City.literalFromJson(Map<String, dynamic> json) {
    String cityId = json['id'];
    String name = json['name'];
    String description = json['description'];
    Map<String, dynamic> cityMetrics = jsonDecode(json['cityMetrics']);

    final Map<CityCriteria, int> _cityRatingsDynamic = {};
    cityMetrics.forEach((key, value) {
      _cityRatingsDynamic[CityCriteria.values.firstWhere((e) => e.name == value['criteria'])] = value['metric'];
    });

    return City(cityId, name, description, _cityRatingsDynamic, [], "0");
  }

  factory City.fromJson(Map<String, dynamic> json) {
    City literalFromJson = City.literalFromJson(json);

    List<dynamic> routeList = json['routes'];
    List<Route.Route> routes = [];
    routeList.forEach((route) {
      routes.add(Route.Route.fromJson(route));
    });

    return City(literalFromJson.getId, literalFromJson.getName, literalFromJson.getDescription, literalFromJson.getCityRatings, routes, literalFromJson.getCountryId);
  }

  IconData get getIcon => _icon;
  String get getId => _id;
  String get getName => _name;
  String get getDescription => _description;
  Map<CityCriteria, int> get getCityRatings => _cityRatings;
  List<Route.Route> get getRoutes => _routes;
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

  static double calculateAggregateScore(CityCriteria criteria, List<City> routeList) {
    double criteriaScore = 0.0;
    for (var city in routeList) {
      criteriaScore += (city.getCityRatings[criteria]! / routeList.length);
    }
    return double.parse(criteriaScore.toStringAsFixed(2));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          _icon == other._icon &&
          _id == other._id &&
          _name == other._name &&
          _description == other._description &&
          _cityRatings == other._cityRatings &&
          _countryId == other._countryId;

  @override
  int get hashCode =>
      _icon.hashCode ^
      _id.hashCode ^
      _name.hashCode ^
      _description.hashCode ^
      _cityRatings.hashCode ^
      _countryId.hashCode;

  @override
  String toString() {
    return 'City{_icon: $_icon, _id: $_id, _name: $_name, _description: $_description, _cityRatings: $_cityRatings, _routes: $_routes, _countryId: $_countryId}';
  }
}