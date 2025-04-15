import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/domain/transport_type.dart';
import 'package:nomad/screens/route_book/providers/route_instance_provider.dart';
import 'package:collection/collection.dart';
import 'package:nomad/screens/route_book/route_instance_constants.dart';


final categorizedRouteInstanceProvider = NotifierProvider<CategorizedRouteInstanceNotifier, Map<TransportType, List<RouteInstance>>>(CategorizedRouteInstanceNotifier.new);

class CategorizedRouteInstanceNotifier extends Notifier<Map<TransportType, List<RouteInstance>>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('categorized_route_instances_provider.dart'));

  @override
  Map<TransportType, List<RouteInstance>> build() {
    final asyncRouteInstances = ref.watch(routeInstanceProvider);

    return asyncRouteInstances.when(
      data: (routeInstances) {
        if (routeInstances.isEmpty) {
          return {};
        }

        final grouped = groupBy(routeInstances, (RouteInstance ri) => ri.getTransportType);

        final Map<TransportType, List<RouteInstance>> categorizedRoutes = Map.from(grouped);
        if (routeInstances.isNotEmpty) { // Only add ALL if there are routes
          categorizedRoutes[TransportType.ALL] = routeInstances.toList();
        }

        return categorizedRoutes;
      },
      loading: () => {},
      error: (error, stackTrace) {
        _logger.w(
            'Tried to categorize routes when state has no value. Returning empty set');
        return {};
      },
    );
  }

  List<TransportType> sortKeysByPreferredTransportType() {
    final availableTransportTypes = state.keys.toList();

    // Sort the available modes based on the preferred order
    availableTransportTypes.sort((a, b) {
      final indexA = kRouteInstanceTabOrder.indexOf(a);
      final indexB = kRouteInstanceTabOrder.indexOf(b);

      // Handle cases where a type might not be in the preferred list (put them at the end)
      final effectiveIndexA = (indexA == -1) ? kRouteInstanceTabOrder.length : indexA;
      final effectiveIndexB = (indexB == -1) ? kRouteInstanceTabOrder.length : indexB;

      return effectiveIndexA.compareTo(effectiveIndexB);
    });

    return availableTransportTypes;
  }

  void sortMapValuesByFilter(String sortFilter) {
    for (TransportType type in state.keys) {
      switch (sortFilter) {
        case 'Price: Low to High':
          state[type]!.sort((a, b) => a.getCost.compareTo(b.getCost));
          break;
        case 'Price: High to Low':
          state[type]!.sort((a, b) => b.getCost.compareTo(a.getCost));
          break;
        case 'Duration: Shortest':
          state[type]!.sort((a, b) => a.getTravelTime.compareTo(b.getTravelTime));
          break;
        case 'Departure: Earliest':
          state[type]!.sort((a, b) => a.getDeparture.compareTo(b.getDeparture));
          break;
        case 'Departure: Latest':
          state[type]!.sort((a, b) => b.getDeparture.compareTo(a.getDeparture));
          break;
        case 'Arrival: Earliest':
          state[type]!.sort((a, b) => a.getArrival.compareTo(b.getArrival));
          break;
        case 'Arrival: Latest':
          state[type]!.sort((a, b) => b.getArrival.compareTo(a.getArrival));
          break;
      }
    }
    ref.notifyListeners();

  }
}