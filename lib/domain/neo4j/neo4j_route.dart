import 'package:iso_duration_parser/iso_duration_parser.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/transport_type.dart';

import 'neo4j_city.dart';

class Neo4jRoute {
  static Logger _logger = Logger(printer: CustomLogPrinter('neo4j_city.dart'));

  final String _id;
  final double _popularity;
  final Duration _averageDuration;
  final double _averageCost;
  final TransportType _transportType;
  final Neo4jCity _targetCity;

  // These are computed from the Query on the backend and not actually stored in the java Neo4jRoute entity
  final double _score;
  final double _distance;

  Neo4jRoute(this._id, this._popularity, this._averageDuration, this._averageCost, this._transportType, this._targetCity, this._score, this._distance);

  String get getId => _id;
  double get getPopularity => _popularity;
  Duration get getAverageDuration => _averageDuration;
  double get getAverageCost => _averageCost;
  TransportType get getTransportType => _transportType;
  Neo4jCity get getTargetCity => _targetCity;
  double get getScore => _score;
  double get getDistance => _distance;

  factory Neo4jRoute.fromRouteInfoDTO(Map<String, dynamic> json) {
    Neo4jRoute neo4jRoute = Neo4jRoute.fromJson(json['neo4jRoute']);
    double score = double.parse((json['score']).toStringAsFixed(2));
    double distance = json['distance'];
    neo4jRoute = Neo4jRoute(neo4jRoute.getId, neo4jRoute.getPopularity, neo4jRoute.getAverageDuration, neo4jRoute.getAverageCost, neo4jRoute.getTransportType, neo4jRoute.getTargetCity, score, distance);
    return neo4jRoute;
  }

  factory Neo4jRoute.fromJson(Map<String, dynamic> json) {
    String routeId = json['id'];
    double popularity = double.parse((json['popularity']).toStringAsFixed(2));
    IsoDuration parsedDuration = IsoDuration.parse(json['averageDuration']);
    Duration averageDuration = Duration(days: parsedDuration.days.toInt(), hours: parsedDuration.hours.toInt(), minutes: parsedDuration.minutes.toInt());

    double averageCost = json['averageCost'];
    TransportType transportType = TransportType.values.firstWhere((e) => e.name == json['transportType']);
    Neo4jCity targetCity = Neo4jCity.literalFromJson(json['targetCity']);

    return Neo4jRoute(routeId, popularity, averageDuration, averageCost, transportType, targetCity, 0, 0);
  }

  @override
  String toString() {
    return 'Neo4jRoute{_id: $_id, _popularity: $_popularity, _averageDuration: $_averageDuration, _averageCost: $_averageCost, _transportType: $_transportType, _targetCity: $_targetCity, _score: $_score, _distance: $_distance}';
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
          _targetCity == other._targetCity &&
          _score == other._score &&
          _distance == other._distance;

  @override
  int get hashCode =>
      _id.hashCode ^
      _popularity.hashCode ^
      _averageDuration.hashCode ^
      _averageCost.hashCode ^
      _transportType.hashCode ^
      _targetCity.hashCode ^
      _score.hashCode ^
      _distance.hashCode;
}