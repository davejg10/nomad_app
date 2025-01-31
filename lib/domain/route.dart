import 'package:nomad/domain/transport_type.dart';

import 'city.dart';

class Route {

  final String _id;
  final int _popularity;
  final int _weight;
  final TransportType _transportType;
  final City _targetCity;

  Route(this._id, this._popularity, this._weight, this._transportType, this._targetCity);

  String get getId => _id;
  int get getPopularity => _popularity;
  int get getWeight => _weight;
  TransportType get getTransportType => _transportType;
  City get getTargetCity => _targetCity;

  factory Route.fromJson(Map<String, dynamic> json) {
    String routeId = json['id'];
    int popularity = json['popularity'];
    int weight = json['weight'];
    TransportType transportType = TransportType.values.firstWhere((e) => e.name == json['transportType']);
    City targetCity = City.literalFromJson(json['targetCity']);
    return Route(routeId, popularity, weight, transportType, targetCity);
  }

  @override
  String toString() {
    return 'Route{_id: $_id, _popularity: $_popularity, _weight: $_weight, _transportType: $_transportType, _targetCity: $_targetCity}';
  }
}