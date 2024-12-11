import 'package:flutter/material.dart';

class City {

  final IconData _icon = Icons.location_city;
  final int _id;
  final String _name;
  final String _description;
  final int _countryId;

  City(this._id, this._name, this._description, this._countryId);

  IconData get getIcon => _icon;
  int get getId => _id;
  String get getName => _name;
  String get getDescription => _description;
  int get getCountryId => _countryId;
}