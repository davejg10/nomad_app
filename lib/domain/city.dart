import 'package:flutter/material.dart';

class City {

  final IconData _icon = Icons.location_city;
  final int _id;
  final String _name;
  final String _description;
  final Map<String, int> _cityRatings = {
    'sailing': 9,
    'food': 7,
    'nightlife': 8
  };
  final int _countryId;

  City(this._id, this._name, this._description, this._countryId);

  IconData get getIcon => _icon;
  int get getId => _id;
  String get getName => _name;
  String get getDescription => _description;
  Map<String, int> get getCityRatings => _cityRatings;
  int get getCountryId => _countryId;

  static IconData convertCriteriaToIcon(String criteria) {
    switch (criteria) {
      case 'sailing':
        return Icons.sailing;
      case 'food':
        return Icons.restaurant;
      case 'nightlife':
        return Icons.local_bar;
      default:
        throw Exception('no mapping for criterian');
    }
  }
}