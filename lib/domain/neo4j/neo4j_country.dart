import 'package:flutter/material.dart';

import '../geo_entity.dart';


class Neo4jCountry implements GeoEntity {

  final IconData _icon = Icons.south_america;
  final String _id;
  final String _name;
  final String _shortDescription;
  final String _primaryBlobUrl;

  Neo4jCountry(this._id, this._name, this._shortDescription, this._primaryBlobUrl);

  factory Neo4jCountry.fromJson(Map<String, dynamic> json) {
    String countryId = json['id'];
    String name = json['name'];
    String shortDescription = json['shortDescription'];
    String primaryBlobUrl = json['primaryBlobUrl'];

    return Neo4jCountry(countryId, name, shortDescription, primaryBlobUrl);
  }

  IconData get getIcon => _icon;
  String get getId => _id;
  String get getName => _name;
  String get getShortDescription => _shortDescription;
  String get getPrimaryBlobUrl => _primaryBlobUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Neo4jCountry &&
          runtimeType == other.runtimeType &&
          _icon == other._icon &&
          _id == other._id &&
          _name == other._name;

  @override
  int get hashCode =>
      _icon.hashCode ^ _id.hashCode ^ _name.hashCode;

  @override
  String toString() {
    return 'Country{_icon: $_icon, _id: $_id, _name: $_name, _shortDescription: $_shortDescription, _primaryBlobUrl: $_primaryBlobUrl}';
  }
}