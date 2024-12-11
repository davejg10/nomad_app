import 'package:flutter/material.dart';

class Country {

  final IconData _icon = Icons.south_america;
  final int _id;
  final String _name;
  final String _description;

  Country(this._id, this._name, this._description);

  IconData get getIcon => _icon;
  int get getId => _id;
  String get getName => _name;
  String get getDescription => _description;
}