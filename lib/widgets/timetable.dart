import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

String origin = 'Bangkok';
String destination = 'Phuket';
final List<TransportRoute> routes = [
  TransportRoute(
    transportMode: 'Flight',
    provider: 'Air Europa',
    price: 129.99,
    durationMinutes: 105,
    departureTime: DateTime(2025, 3, 24, 10, 15),
    arrivalTime: DateTime(2025, 3, 24, 12, 0),
    departureLocation: 'Barcelona Airport (BCN)',
    arrivalLocation: 'Madrid Airport (MAD)',
    details: 'Direct',
    bookingUrl: 'https://example.com/book/flight1',
  ),
  TransportRoute(
    transportMode: 'Flight',
    provider: 'Iberia',
    price: 149.99,
    durationMinutes: 95,
    departureTime: DateTime(2025, 3, 24, 14, 30),
    arrivalTime: DateTime(2025, 3, 24, 16, 5),
    departureLocation: 'Barcelona Airport (BCN)',
    arrivalLocation: 'Madrid Airport (MAD)',
    details: 'Direct',
    bookingUrl: 'https://example.com/book/flight2',
  ),
  TransportRoute(
    transportMode: 'Train',
    provider: 'AVE',
    price: 89.50,
    durationMinutes: 150,
    departureTime: DateTime(2025, 3, 24, 9, 0),
    arrivalTime: DateTime(2025, 3, 24, 11, 30),
    departureLocation: 'Barcelona Sants',
    arrivalLocation: 'Madrid Atocha',
    details: 'High-speed',
    bookingUrl: 'https://example.com/book/train1',
  ),
  TransportRoute(
    transportMode: 'Bus',
    provider: 'ALSA',
    price: 45.00,
    durationMinutes: 390,
    departureTime: DateTime(2025, 3, 24, 8, 30),
    arrivalTime: DateTime(2025, 3, 24, 15, 0),
    departureLocation: 'Barcelona Nord Bus Station',
    arrivalLocation: 'Madrid Estación Sur',
    details: 'WiFi, Power Outlets',
    bookingUrl: 'https://example.com/book/bus1',
  ),
  TransportRoute(
    transportMode: 'Ferry',
    provider: 'Baleària',
    price: 75.00,
    durationMinutes: 480,
    departureTime: DateTime(2025, 3, 24, 22, 0),
    arrivalTime: DateTime(2025, 3, 25, 6, 0),
    departureLocation: 'Barcelona Port',
    arrivalLocation: 'Valencia Port',
    details: 'Overnight ferry',
    bookingUrl: 'https://example.com/book/ferry1',
  ),
];


class TransportRoutesPage extends StatefulWidget {
  final String originCity;
  final String destinationCity;
  final List<TransportRoute> routes;

  const TransportRoutesPage({
    Key? key,
    required this.originCity,
    required this.destinationCity,
    required this.routes,
  }) : super(key: key);

  @override
  _TransportRoutesPageState createState() => _TransportRoutesPageState();
}

class _TransportRoutesPageState extends State<TransportRoutesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> _transportModes = [];
  Map<String, List<TransportRoute>> _categorizedRoutes = {};
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
    _categorizeRoutes();
    _tabController = TabController(length: _transportModes.length, vsync: this);
  }

  void _categorizeRoutes() {
    // Group routes by transport mode
    for (var route in widget.routes) {
      if (!_categorizedRoutes.containsKey(route.transportMode)) {
        _categorizedRoutes[route.transportMode] = [];
      }
      _categorizedRoutes[route.transportMode]!.add(route);
    }

    // Extract transport modes and sort them in a logical order
    _transportModes = _categorizedRoutes.keys.toList();
    final preferredOrder = ['Flight', 'Train', 'Bus', 'Ferry', 'Car', 'Other'];

    _transportModes.sort((a, b) {
      final indexA = preferredOrder.indexOf(a) >= 0 ? preferredOrder.indexOf(a) : 999;
      final indexB = preferredOrder.indexOf(b) >= 0 ? preferredOrder.indexOf(b) : 999;
      return indexA.compareTo(indexB);
    });

    // Apply initial sorting
    _sortRoutes();
  }

  void _sortRoutes() {
    for (var mode in _transportModes) {
      switch (_selectedSortOption) {
        case 'Price: Low to High':
          _categorizedRoutes[mode]!.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Price: High to Low':
          _categorizedRoutes[mode]!.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Duration: Shortest':
          _categorizedRoutes[mode]!.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
          break;
        case 'Departure: Earliest':
          _categorizedRoutes[mode]!.sort((a, b) => a.departureTime.compareTo(b.departureTime));
          break;
        case 'Departure: Latest':
          _categorizedRoutes[mode]!.sort((a, b) => b.departureTime.compareTo(a.departureTime));
          break;
        case 'Arrival: Earliest':
          _categorizedRoutes[mode]!.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
          break;
        case 'Arrival: Latest':
          _categorizedRoutes[mode]!.sort((a, b) => b.arrivalTime.compareTo(a.arrivalTime));
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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.originCity} to ${widget.destinationCity}'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _transportModes.map((mode) {
            IconData icon = _getIconForMode(mode);
            return Tab(
              icon: Icon(icon),
              text: mode,
            );
          }).toList(),
        ),
        actions: [
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
      body: Column(
        children: [
          // Sort chip indicator
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

          // Main tab view
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _transportModes.map((mode) {
                return _buildRoutesList(mode, _categorizedRoutes[mode]!);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutesList(String mode, List<TransportRoute> routes) {
    if (routes.isEmpty) {
      return const Center(
        child: Text('No routes available'),
      );
    }

    return ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return _buildRouteCard(route, mode);
      },
    );
  }

  Widget _buildRouteCard(TransportRoute route, String mode) {
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    // Format duration
    final hours = route.durationMinutes ~/ 60;
    final minutes = route.durationMinutes % 60;
    final durationText = hours > 0
        ? '$hours h ${minutes > 0 ? '$minutes min' : ''}'
        : '$minutes min';

    // Format price
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final priceText = currencyFormat.format(route.price);

    // Departure and arrival dates/times
    final departureDate = dateFormat.format(route.departureTime);
    final departureTime = timeFormat.format(route.departureTime);
    final arrivalDate = dateFormat.format(route.arrivalTime);
    final arrivalTime = timeFormat.format(route.arrivalTime);

    // Check if departure and arrival are on the same day
    final sameDay = route.departureTime.year == route.arrivalTime.year &&
        route.departureTime.month == route.arrivalTime.month &&
        route.departureTime.day == route.arrivalTime.day;

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
                      _getIconForMode(mode),
                      color: _getColorForMode(mode),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      route.provider,
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
                      color: _getColorForMode(mode),
                      size: 16,
                    ),
                    Container(
                      width: 2,
                      height: 40,
                      color: _getColorForMode(mode).withOpacity(0.5),
                    ),
                    Icon(
                      Icons.location_on,
                      color: _getColorForMode(mode),
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
                        route.departureLocation,
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
                        route.arrivalLocation,
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
                if (route.details.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      route.details,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Book now button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColorForMode(mode),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  final Uri url = Uri.parse(route.bookingUrl);
                  // if (!await launchUrl(url)) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text('Could not launch booking website'),
                  //     ),
                  //   );
                  // }
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

  IconData _getIconForMode(String mode) {
    switch (mode.toLowerCase()) {
      case 'flight':
        return Icons.flight;
      case 'train':
        return Icons.train;
      case 'bus':
        return Icons.directions_bus;
      case 'ferry':
        return Icons.directions_boat;
      case 'car':
        return Icons.directions_car;
      default:
        return Icons.directions;
    }
  }

  Color _getColorForMode(String mode) {
    switch (mode.toLowerCase()) {
      case 'flight':
        return Colors.blue;
      case 'train':
        return Colors.orange;
      case 'bus':
        return Colors.green;
      case 'ferry':
        return Colors.lightBlue;
      case 'car':
        return Colors.red;
      default:
        return Colors.purple;
    }
  }
}

// Model class for transport routes
class TransportRoute {
  final String transportMode;
  final String provider;
  final double price;
  final int durationMinutes;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String departureLocation;
  final String arrivalLocation;
  final String details;
  final String bookingUrl;

  TransportRoute({
    required this.transportMode,
    required this.provider,
    required this.price,
    required this.durationMinutes,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureLocation,
    required this.arrivalLocation,
    this.details = '',
    required this.bookingUrl,
  });
}