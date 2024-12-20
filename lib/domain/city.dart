import 'package:flutter/material.dart';

import 'city_criteria.dart';

class City {

  final IconData _icon = Icons.location_city;
  final int _id;
  final String _name;
  final String _description;
  final Map<CityCriteria, int> _cityRatings = {
    CityCriteria.SAILING: 9,
    CityCriteria.FOOD: 7,
    CityCriteria.NIGHTLIFE: 8
  };
  final int _countryId;

  City(this._id, this._name, this._description, this._countryId);

  IconData get getIcon => _icon;
  int get getId => _id;
  String get getName => _name;
  String get getDescription => _description;
  Map<CityCriteria, int> get getCityRatings => _cityRatings;
  int get getCountryId => _countryId;

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
}