import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/screens/map_view/mapbox_utils.dart';
import 'package:nomad/screens/map_view/widgets/city_overlay_card.dart';

class CityOverlayPageView extends ConsumerStatefulWidget {
  CityOverlayPageView({
    super.key,
    required this.itinerary,
    required this.routeList,
    this.mapboxMap
  });

  final List<Neo4jCity> itinerary;
  final Map<int, RouteInstance> routeList;
  late MapboxMap? mapboxMap;

  @override
  ConsumerState<CityOverlayPageView> createState() => _CityOverlayPageViewState();
}

class _CityOverlayPageViewState extends ConsumerState<CityOverlayPageView> {

  late PageController _pageController;
  int _currentPageIndex = 0; // State variable to hold the current snapped page index

  // Adjust viewportFraction to control how much of the next/previous items are visible
  // A value < 1.0 centers the current item and shows neighbours.
  // A value of 1.0 shows only one item filling the PageView width.
  static const double _viewportFraction = 0.8; // Example: 80% width for each item

  @override
  void initState() {
    super.initState();
    // Initialize PageController
    _pageController = PageController(
      initialPage: _currentPageIndex,
      viewportFraction: _viewportFraction, // Make pages take less than full width
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PageView.builder(
      controller: _pageController, // Assign the controller
      itemCount: widget.itinerary.length,
      scrollDirection: Axis.horizontal,
      // This callback fires when the page (item) settles after scrolling/snapping
      onPageChanged: (int index) async {
        setState(() {
          _currentPageIndex = index; // Update the current index
        });

        MapboxUtils.animateMapToCity(widget.mapboxMap, widget.itinerary, widget.routeList, index);
      },
      itemBuilder: (context, index) {
        Neo4jCity selectedCity = widget.itinerary[index];

        final bool isOriginCity = index == 0;
        final Neo4jCity lastCitySelected = isOriginCity ? selectedCity : widget.itinerary[index - 1];

        return CityOverlayCard(
            viewportFraction: _viewportFraction,
            lastCitySelected: lastCitySelected,
            selectedCity: selectedCity
        );
      },
    );
  }
}
