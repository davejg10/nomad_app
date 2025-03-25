import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/route_metric.dart';

import '../domain/neo4j/neo4j_route.dart';

final routeListProvider = NotifierProvider<RouteList, List<Neo4jRoute>>(RouteList.new);

class RouteList extends Notifier<List<Neo4jRoute>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('route_list_provider.dart'));

  @override
  List<Neo4jRoute> build() {
    return [];
  }

  void addToItinerary(Neo4jRoute selectedRoute) {
    state = [...state, selectedRoute];
  }

  void removeFromItinerary(Neo4jRoute selectedRoute) {
    state = state.where((route) => route != selectedRoute).toList();
  }

  void removeLastFromItinerary() {
    state = state.sublist(0, state.length - 1);
  }

  double calculateRouteCostTotal(RouteMetric cost) {
    double total = 0;
    for (Neo4jRoute route in state) {
      total += route.getAverageCost;
    }
    return total;
  }

  double calculateRouteMetricTotal(RouteMetric metric) {
    double total = 0;
    for (Neo4jRoute route in state) {
      total += metric == RouteMetric.AVERAGE_DURATION ? 0 : route.getPopularity;
    }
    return double.parse(total.toStringAsFixed(2));
  }

  double calculateCityCriteriaTotal(CityCriteria criteria) {
    List<Neo4jCity> allCities = state.map((route) => route.getTargetCity).toList();
    double criteriaScore = 0.0;
    for (Neo4jCity city in allCities) {
      criteriaScore += (city.getCityRatings[criteria]! / state.length);
    }
    return double.parse(criteriaScore.toStringAsFixed(2));
  }
}
