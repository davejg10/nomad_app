import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/screens/route_book/providers/route_instance_provider.dart';
import 'package:nomad/widgets/screen_scaffold.dart';
import 'package:nomad/widgets/single_date_select.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom_log_printer.dart';
import '../../domain/neo4j/neo4j_city.dart';
import '../../domain/sql/route_instance.dart';
import '../../domain/transport_type.dart';
import '../select_city/widgets/city_card_shimmer.dart';

class RouteBookScreen extends ConsumerStatefulWidget {
  RouteBookScreen({
    super.key,
    required this.sourceCity,
    required this.targetCity,
    required this.routes,
    required this.searchDate,
  });

  final Neo4jCity sourceCity;
  final Neo4jCity targetCity;
  final Set<Neo4jRoute> routes;
  DateTime searchDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RouteBookScreenState();
}

class _RouteBookScreenState extends ConsumerState<RouteBookScreen> with TickerProviderStateMixin {
  static Logger _logger = Logger(printer: CustomLogPrinter('route_book_screen.dart'));

  late TabController _tabController;
  late Set<RouteInstance> routeInstances;
  List<TransportType> _transportModes = [];
  Map<TransportType, List<RouteInstance>> _categorizedRoutes = {};
  String _selectedSortOption = 'Price: Low to High';
  final List<String> _sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'Duration: Shortest',
    'Departure: Earliest',
    'Departure: Latest',
    'Arrival: Earliest',
    'Arrival: Latest',
  ];

  @override
  void initState() {
    super.initState();
  }

  void loadRoutes(Set<RouteInstance> routeInstances) async {

    _categorizeRoutes(routeInstances);
    _sortRoutes();
  }


  void _categorizeRoutes(Set<RouteInstance> routeInstances) {
    _categorizedRoutes = {};
    for (RouteInstance routeInstance in routeInstances) {
      if (!_categorizedRoutes.containsKey(routeInstance.getTransportType)) {
        _categorizedRoutes[routeInstance.getTransportType] = [];
      }
      _categorizedRoutes[routeInstance.getTransportType]!.add(routeInstance);
    }
    _categorizedRoutes[TransportType.ALL] = routeInstances.toList();
    // Extract transport modes and sort them in a logical order
    _transportModes = _categorizedRoutes.keys.toList();
    _tabController = TabController(length: _transportModes.length, vsync: this);

    final preferredOrder = ['ALL', 'FLIGHT', 'TRAIN', 'BUS', 'FERRY', 'VAN', 'Other'];

    _transportModes.sort((a, b) {
      final indexA = preferredOrder.indexOf(a.name) >= 0 ? preferredOrder.indexOf(a.name) : 999;
      final indexB = preferredOrder.indexOf(b.name) >= 0 ? preferredOrder.indexOf(b.name) : 999;
      return indexA.compareTo(indexB);
    });
  }

  void _sortRoutes() {
    for (TransportType type in _transportModes) {
      switch (_selectedSortOption) {
        case 'Price: Low to High':
          _categorizedRoutes[type]!.sort((a, b) => a.getCost.compareTo(b.getCost));
          break;
        case 'Price: High to Low':
          _categorizedRoutes[type]!.sort((a, b) => b.getCost.compareTo(a.getCost));
          break;
        case 'Duration: Shortest':
          _categorizedRoutes[type]!.sort((a, b) => a.getTravelTime.compareTo(b.getTravelTime));
          break;
        case 'Departure: Earliest':
          _categorizedRoutes[type]!.sort((a, b) => a.getDeparture.compareTo(b.getDeparture));
          break;
        case 'Departure: Latest':
          _categorizedRoutes[type]!.sort((a, b) => b.getDeparture.compareTo(a.getDeparture));
          break;
        case 'Arrival: Earliest':
          _categorizedRoutes[type]!.sort((a, b) => a.getArrival.compareTo(b.getArrival));
          break;
        case 'Arrival: Latest':
          _categorizedRoutes[type]!.sort((a, b) => b.getArrival.compareTo(a.getArrival));
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeInstanceState = ref.watch(routeInstanceProvider);

    return routeInstanceState.when(
      data: (routeInstances) {
        loadRoutes(routeInstances);
        return _buildScreen();
      },
      error: (error, trace) {
        return Container();
      },
      loading: () {
        return ScreenScaffold(
            child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return CityCardShimmer();
                }
            )
        );
      }
    );
  }

  Widget _buildScreen() {
    return ScreenScaffold(
      appBar: AppBar(
        title: Text('${widget.sourceCity.getName} to ${widget.targetCity.getName}'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _transportModes.map((transportType) {
            IconData icon = transportType.getIcon();
            return Tab(
              icon: Icon(icon),
              text: transportType.name,
            );
          }).toList(),
        ),
        actions: [
          SingleDateSelect(
            onDateSubmitted: (DateTime searchDate) {
              ref.read(routeInstanceProvider.notifier).fetchRouteInstance(widget.sourceCity, widget.targetCity, widget.routes, searchDate);
            },
            lastDateSelected: widget.searchDate,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort routes',
            onSelected: (String value) {
              setState(() {
                _selectedSortOption = value;
                _sortRoutes();
              });
            },
            itemBuilder: (BuildContext context) {
              return _sortOptions.map((String option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Row(
                    children: [
                      _selectedSortOption == option
                          ? const Icon(Icons.check, size: 16)
                          : const SizedBox(width: 16),
                      const SizedBox(width: 8),
                      Text(option),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.sort, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Sorted by: $_selectedSortOption',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _transportModes.map((transportType) {
                return _buildRoutesList(transportType, _categorizedRoutes[transportType]!);
              }).toList(),
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildRoutesList(TransportType transportType, List<RouteInstance> routeInstances) {
    if (routeInstances.isEmpty) {
      return const Center(
        child: Text('No routes available'),
      );
    }

    return ListView.builder(
      itemCount: routeInstances.length,
      itemBuilder: (context, index) {
        final routeInstance = routeInstances[index];
        return _buildRouteCard(routeInstance, transportType);
      },
    );
  }

  Widget _buildRouteCard(RouteInstance routeInstance, TransportType transportType) {
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    // Format duration
    final hours = routeInstance.getTravelTime.inMinutes ~/ 60;
    final minutes = routeInstance.getTravelTime.inMinutes % 60;
    final durationText = hours > 0
        ? '$hours h ${minutes > 0 ? '$minutes min' : ''}'
        : '$minutes min';

    // Format price
    final currencyFormat = NumberFormat.currency(symbol: '\£');
    final priceText = currencyFormat.format(routeInstance.getCost);

    DateTime routeDeparture = routeInstance.getDeparture;
    DateTime routeArrival = routeInstance.getArrival;

    // Departure and arrival dates/times
    final departureDate = dateFormat.format(routeDeparture);
    final departureTime = timeFormat.format(routeDeparture);
    final arrivalDate = dateFormat.format(routeArrival);
    final arrivalTime = timeFormat.format(routeArrival);

    // Check if departure and arrival are on the same day
    final sameDay = routeDeparture.year == routeArrival.year &&
        routeDeparture.month == routeArrival.month &&
        routeDeparture.day == routeArrival.day;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider and price row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      routeInstance.getTransportType.getIcon(),
                      color: routeInstance.getTransportType.getColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      routeInstance.getOperator,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  label: Text(
                    priceText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(),

            // Departure and arrival info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline column
                Column(
                  children: [
                    Icon(
                      Icons.circle_outlined,
                      color: routeInstance.getTransportType.getColor(),
                      size: 16,
                    ),
                    Container(
                      width: 2,
                      height: 40,
                      color: routeInstance.getTransportType.getColor().withOpacity(0.5),
                    ),
                    Icon(
                      Icons.location_on,
                      color: routeInstance.getTransportType.getColor(),
                      size: 16,
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                // Time and location details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            departureTime,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            departureDate,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        routeInstance.getDepartureLocation,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            arrivalTime,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            sameDay ? '(Same day)' : arrivalDate,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        routeInstance.getArrivalLocation,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Duration and details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      durationText,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                // if (route.details.isNotEmpty)
                //   Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //     decoration: BoxDecoration(
                //       color: Colors.grey[200],
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Text(
                //       route.details,
                //       style: TextStyle(
                //         fontSize: 12,
                //         color: Colors.grey[800],
                //       ),
                //     ),
                //   ),
              ],
            ),

            const SizedBox(height: 16),

            // Book now button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: routeInstance.getTransportType.getColor(),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  final Uri url = Uri.parse(routeInstance.getUrl);
                  if (!await launchUrl(url)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not launch booking website'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
