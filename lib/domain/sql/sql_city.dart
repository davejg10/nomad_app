
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/city_criteria.dart';

class SqlCity {
  static Logger _logger = Logger(printer: CustomLogPrinter('sql_city.dart'));

  final String _id;
  final String _name;
  final String _description;
  final Map<CityCriteria, double> _cityMetrics;
  final String _countryId;

  SqlCity(this._id, this._name, this._description, this._cityMetrics, this._countryId);

  factory SqlCity.fromJson(Map<String, dynamic> json) {

    try {
      String id = json['id'];
      String name = json['name'];
      String description = json['description'];
      List<dynamic> cityMetrics = json['cityMetrics'];
      final Map<CityCriteria, double> _cityMetrics = {};
      if (cityMetrics.isNotEmpty) {
        cityMetrics.forEach((cityMetric) {
          _cityMetrics[CityCriteria.values.firstWhere((e) => e.name == cityMetric['criteria'])] = double.parse((cityMetric['metric']).toStringAsFixed(2));
        });
      }

      String countryId = json['countryId'];
      return SqlCity(id, name, description, _cityMetrics, countryId);

    } catch (e, stackTrace) {
      _logger.w("An unexpected exception occured whilst trying to deserialize the Json in SqlCity.fromJson ${e.toString()}", error: e, stackTrace: stackTrace);
      throw e;
    }
  }

  String get getId => _id;
  String get getName => _name;
  String get getDescription => _description;
  Map<CityCriteria, double> get getCityRatings => _cityMetrics;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlCity &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _name == other._name &&
          _description == other._description &&
          _cityMetrics == other._cityMetrics &&
          _countryId == other._countryId;

  @override
  int get hashCode =>
      _id.hashCode ^
      _name.hashCode ^
      _description.hashCode ^
      _cityMetrics.hashCode ^
      _countryId.hashCode;
}