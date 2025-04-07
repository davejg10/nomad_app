
import 'package:iso_duration_parser/iso_duration_parser.dart';
import 'package:logger/logger.dart';

import '../../custom_log_printer.dart';
import '../transport_type.dart';

class RouteInstance {
  static Logger _logger = Logger(printer: CustomLogPrinter('route_instance.dart'));

  final String _id;
  final double _cost;
  final DateTime _departure;
  final DateTime _arrival;
  final String _operator;
  final String _departureLocation;
  final String _arrivalLocation;
  final String _url;
  final Duration _travelTime;
  final TransportType _transportType;

  RouteInstance(this._id, this._cost, this._departure, this._arrival, this._operator, this._departureLocation, this._arrivalLocation, this._url, this._travelTime, this._transportType);

  factory RouteInstance.fromJson(Map<String, dynamic> json) {
    try {
      String id = json['id'];
      double cost = json['cost'];
      DateTime departure = DateTime.parse(json['departure']);
      DateTime arrival = DateTime.parse(json['arrival']);
      String operator = json['operator'];
      String departureLocation = json['departureLocation'];
      String arrivalLocation = json['arrivalLocation'];
      String url = json['url'];
      IsoDuration parsedDuration = IsoDuration.parse(json['travelTime']);
      Duration travelTime = Duration(days: parsedDuration.days.toInt(), hours: parsedDuration.hours.toInt(), minutes: parsedDuration.minutes.toInt());
      TransportType transportType = TransportType.values.firstWhere((e) => e.name == json['routeDefinition']['transportType']);

      return RouteInstance(id, cost, departure, arrival, operator, departureLocation, arrivalLocation, url, travelTime, transportType);
    } catch (e, stackTrace) {
      _logger.w("An unexpected error occurred whilst trying to deserialize the Json in RouteInstance.fromJson $e, $stackTrace");
      throw e;
    }
  }

  String get getId => _id;
  double get getCost => _cost;
  DateTime get getDeparture => _departure;
  DateTime get getArrival => _arrival;
  String get getOperator => _operator;
  String get getDepartureLocation => _departureLocation;
  String get getArrivalLocation => _arrivalLocation;
  String get getUrl => _url;
  Duration get getTravelTime => _travelTime;
  TransportType get getTransportType => _transportType;
}