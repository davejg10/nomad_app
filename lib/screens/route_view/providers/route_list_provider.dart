// import 'package:logger/logger.dart';
// import 'package:nomad/custom_log_printer.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nomad/domain/city_criteria.dart';
// import 'package:nomad/domain/neo4j/neo4j_city.dart';
// import 'package:nomad/domain/neo4j/neo4j_route.dart';
//
// final routeListProvider = NotifierProvider<RouteListNotifier, List<Neo4jCity>>(RouteListNotifier.new);
//
// class RouteListNotifier extends Notifier<List<Neo4jRoute>> {
//   static Logger _logger = Logger(printer: CustomLogPrinter('itinerary_list_provider.dart'));
//
//   @override
//   List<Neo4jCity> build() {
//     return [];
//   }
//
//   void addToItinerary(Neo4jCity selectedCity) {
//     state = [...state, selectedCity];
//   }
//
//   void removeFromItinerary(Neo4jCity selectedCity) {
//     state = state.where((city) => city != selectedCity).toList();
//   }
//
//   void removeLastFromItinerary() {
//     state = state.sublist(0, state.length - 1);
//   }
//
//   double calculateCityCriteriaTotal(CityCriteria criteria) {
//     double criteriaScore = 0.0;
//     for (Neo4jCity city in state) {
//       criteriaScore += (city.getCityRatings[criteria]! / state.length);
//     }
//     return double.parse(criteriaScore.toStringAsFixed(2));
//   }
// }
