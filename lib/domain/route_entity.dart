import 'package:nomad/domain/transport_type.dart';

import 'city.dart';

class RouteEntity {

  final String _id;
  final double _popularity;
  final double _time;
  final double _cost;
  final TransportType _transportType;
  final City _targetCity;

  RouteEntity(this._id, this._popularity, this._time, this._cost, this._transportType, this._targetCity);

  String get getId => _id;
  double get getPopularity => _popularity;
  double get getTime => _time;
  double get getCost => _cost;
  TransportType get getTransportType => _transportType;
  City get getTargetCity => _targetCity;

  factory RouteEntity.fromJson(Map<String, dynamic> json) {
    String routeId = json['id'];
    double popularity = double.parse((json['popularity']).toStringAsFixed(2));
    double time = double.parse((json['time']).toStringAsFixed(2));
    double cost = json['cost'];
    TransportType transportType = TransportType.values.firstWhere((e) => e.name == json['transportType']);
    City targetCity = City.literalFromJson(json['targetCity']);
    return RouteEntity(routeId, popularity, time, cost, transportType, targetCity);
  }

  @override
  String toString() {
    return 'Route{_id: $_id, _popularity: $_popularity, _time: $_time, _cost: $_cost, _transportType: $_transportType, _targetCity: $_targetCity}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteEntity &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _popularity == other._popularity &&
          _time == other._time &&
          _cost == other._cost &&
          _transportType == other._transportType &&
          _targetCity == other._targetCity;

  @override
  int get hashCode =>
      _id.hashCode ^
      _popularity.hashCode ^
      _time.hashCode ^
      _cost.hashCode ^
      _transportType.hashCode ^
      _targetCity.hashCode;
}