import 'package:nomad/domain/transport_type.dart';

import 'neo4j_city.dart';

class Neo4jRoute {

  final String _id;
  final double _popularity;
  final Duration _averageDuration;
  final double _averageCost;
  final TransportType _transportType;
  final Neo4jCity _targetCity;

  Neo4jRoute(this._id, this._popularity, this._averageDuration, this._averageCost, this._transportType, this._targetCity);

  String get getId => _id;
  double get getPopularity => _popularity;
  Duration get getAverageDuration => _averageDuration;
  double get getAverageCost => _averageCost;
  TransportType get getTransportType => _transportType;
  Neo4jCity get getTargetCity => _targetCity;

  factory Neo4jRoute.fromJson(Map<String, dynamic> json) {
    String routeId = json['id'];
    double popularity = double.parse((json['popularity']).toStringAsFixed(2));
    Duration averageDuration = Duration.zero;

    double averageCost = json['averageCost'];
    TransportType transportType = TransportType.values.firstWhere((e) => e.name == json['transportType']);
    Neo4jCity targetCity = Neo4jCity.literalFromJson(json['targetCity']);
    return Neo4jRoute(routeId, popularity, averageDuration, averageCost, transportType, targetCity);
  }

  @override
  String toString() {
    return 'Route{_id: $_id, _popularity: $_popularity, _averageDuration: $_averageDuration, _averageCost: $_averageCost, _transportType: $_transportType, _targetCity: $_targetCity}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Neo4jRoute &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _popularity == other._popularity &&
          _averageDuration == other._averageDuration &&
          _averageCost == other._averageCost &&
          _transportType == other._transportType &&
          _targetCity == other._targetCity;

  @override
  int get hashCode =>
      _id.hashCode ^
      _popularity.hashCode ^
      _averageDuration.hashCode ^
      _averageCost.hashCode ^
      _transportType.hashCode ^
      _targetCity.hashCode;
}