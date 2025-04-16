import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/screens/route_view/providers/route_list_provider.dart';
import 'package:nomad/screens/route_view/providers/trip_date_providers.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderUtils {

  // The int in the map here refers to the index that can be used to locate the City, RouteInstance in the various providers
  static Map<DateTime, int> plotTrip(List<Neo4jCity> itineraryList, Map<int, RouteInstance> routeList, DateTime start, DateTime finish) {
    Map<DateTime, int> tripCalender = {};
    for (int index = 0; index < itineraryList.length; index++) {
      Neo4jCity neo4jCity = itineraryList[index];

      DateTime cityArriveDate = index == 0 ? start : routeList[index - 1]!.getDeparture;
      DateTime cityLeaveDate = index == itineraryList.length - 1 ? finish : routeList[index]!.getDeparture;
      Duration difference = cityLeaveDate.difference(cityArriveDate);


      tripCalender[CalenderUtils.normalizeDate(cityArriveDate)] = index;
      for (int i = 1; i <= difference.inDays; i ++) {
        DateTime arriveDatePlusDays = cityArriveDate.add(Duration(days: i));
        tripCalender[CalenderUtils.normalizeDate(arriveDatePlusDays)] = index;
      }
    }

    return tripCalender;
  }

  static DateTime normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }
}


class RouteCalenderView extends ConsumerStatefulWidget {
  const RouteCalenderView({
    super.key,
    required this.scrollController
  });

  final ScrollController scrollController;

  @override
  ConsumerState<RouteCalenderView> createState() => _RouteCalenderViewState();
}

class _RouteCalenderViewState extends ConsumerState<RouteCalenderView> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, int> tripCalender;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    List<Neo4jCity> itineraryList = ref.read(itineraryListProvider);
    Map<int, RouteInstance> routeList = ref.read(routeListProvider);
    DateTime tripDateStart = ref.read(tripDateStartProvider)!;
    DateTime now = DateTime.now();
    _focusedDay = tripDateStart.isAfter(now) ? tripDateStart : now;
    _selectedDay = _focusedDay;
    DateTime tripDateFinish = ref.read(tripDateFinishProvider)!;
    tripCalender = CalenderUtils.plotTrip(itineraryList, routeList, tripDateStart, tripDateFinish);
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<int> _getStateProviderIndexForDay(DateTime day) {
    final normalizedDay = CalenderUtils.normalizeDate(day);
    final tripStopIndex = tripCalender[normalizedDay];
    return tripStopIndex != null ? [tripStopIndex] : [];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              TableCalendar<int>( // Specify the event type
                firstDay: DateTime.utc(2025, 1, 1), // Range of the calendar
                lastDay: DateTime.utc(2026, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                // --- Event Loading ---
                eventLoader: _getStateProviderIndexForDay,

                // --- Styling and Customization ---
                calendarStyle: CalendarStyle(
                  // Highlight today
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  // Highlight selected day (optional)
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  // Style for days with events (markers) - default dots below
                  markerDecoration: const BoxDecoration(
                    color: Colors.redAccent, // Color of the default marker dot
                    shape: BoxShape.circle,
                  ),
                  markerSize: 6.0,
                  markersMaxCount: 1, // Show max 1 marker per day
                  // Make weekend days visually distinct (optional)
                  weekendTextStyle: TextStyle(color: Colors.red[600]),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false, // Hide toggle for week/2-week/month
                  titleCentered: true,
                ),

                // --- Custom Builders for Visualization ---
                calendarBuilders: CalendarBuilders(
                  // Build custom markers below the day number
                  markerBuilder: (context, day, events) {

                    if (events.isNotEmpty) {
                      // We have a TripStop for this day
                      final tripStop = events.first; // Assuming one stop per day
                      return Positioned( // Position the image marker nicely
                        bottom: 1,
                        child: _buildEventMarker(tripStop),
                      );
                    }
                    return null; // Return null or empty container if no events
                  },
                  // You can also customize the day cell itself, e.g., defaultBuilder
                  // defaultBuilder: (context, day, focusedDay) { ... }
                ),

                // --- Interaction Callbacks ---
                selectedDayPredicate: (day) {
                  // Decide whether a day can be selected (optional)
                  // Use `isSameDay` for comparison, ignoring time
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay; // Update focused day as well

                      if (tripCalender.containsKey(selectedDay)) {
                        if (widget.scrollController.offset == 0) {
                          widget.scrollController.animateTo(
                            400,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeOut,
                          );
                        }

                      } else {
                        widget.scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 10),
              if (_selectedDay != null)

                _buildSelectedDayDetails(),

            ],
          ),
        )
      ],
    );
  }

  // Helper widget to build the visual marker (country image)
  Widget _buildEventMarker(int stateProviderIndex) {
    Neo4jCity cityForDate = ref.read(itineraryListProvider)[stateProviderIndex];
    return Container(
      width: 24, // Adjust size as needed
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Optional: Add a border
        border: Border.all(color: Colors.grey.shade400, width: 1.0),
        image: DecorationImage(
          image: AssetImage('assets/flags/${cityForDate.getCountry.getName.toLowerCase()}.png'),
          fit: BoxFit.cover,
          // Handle image loading errors gracefully
          onError: (exception, stackTrace) {
            // Optionally log error: print('Error loading image: $exception');
          },
        ),
      ),
      // Fallback in case image fails - uncomment if needed
      // child: Image.asset(
      //   tripStop.imageAssetPath,
      //   fit: BoxFit.cover,
      //   errorBuilder: (context, error, stackTrace) {
      //     // Return a placeholder if image fails
      //     return Container(
      //       color: Colors.grey[300],
      //       child: Icon(Icons.broken_image, size: 16, color: Colors.grey[600]),
      //     );
      //   },
      // ),
    );
  }

  // Optional: Widget to display details below the calendar
  Widget _buildSelectedDayDetails() {

    final events = _getStateProviderIndexForDay(_selectedDay!);
    if (events.isNotEmpty) {
      final stateProviderIndex = events.first;
      Neo4jCity cityForDate = ref.read(itineraryListProvider)[stateProviderIndex];

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Details for ${MaterialLocalizations.of(context).formatShortDate(_selectedDay!)}:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Image.asset('assets/flags/${cityForDate.getCountry.getName.toLowerCase()}.png', height: 100),
            const SizedBox(height: 8),
            Text("Country: ${cityForDate.getCountry.getName}", style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("No trip planned for ${MaterialLocalizations.of(context).formatShortDate(_selectedDay!)}"),
      );
    }
  }
}
