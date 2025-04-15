import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/screens/city_details/city_details_screen.dart';
import 'package:nomad/screens/city_details/providers/sql_city_provider.dart';
import 'package:nomad/screens/select_city/widgets/city_card/city_score_chip.dart';
import 'package:nomad/widgets/generic/screen_scaffold.dart';

import '../../domain/neo4j/neo4j_city.dart';
import 'mapbox_utils.dart';

class MapViewScreen extends ConsumerStatefulWidget {
  MapViewScreen({
    super.key,
    required this.itinerary,
    required this.routeList
  });

  final List<Neo4jCity> itinerary;
  final Map<int, RouteInstance> routeList;

  @override
  ConsumerState<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends ConsumerState<MapViewScreen> {
  MapboxMap? _mapboxMap;
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
    _mapboxMap?.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    if (widget.itinerary.isNotEmpty) {
      widget.itinerary.forEach((city) async => await MapboxUtils.placeMarker(_mapboxMap!, city: city));
      // Fly to the initial city (or originCity if you prefer)
      _animateMapToCity(widget.itinerary[_currentPageIndex], 0);
    }

  }

  void _animateMapToCity(Neo4jCity city, int index) async {
    if (index > 0) {
      Color routeColor = widget.routeList[index-1] != null ? widget.routeList[index-1]!.getTransportType.getColor() : Colors.black;
      await MapboxUtils.createPolyline(_mapboxMap!, sourceCity: widget.itinerary[index - 1], targetCity: widget.itinerary[index], routeColor: routeColor);
    }
    await _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position.named(lat: city.getCoordinates.getLongitude, lng: city.getCoordinates.getLatitude)),
        zoom: 8.0,
        bearing: 0.0,
        pitch: 30,
      ),
      MapAnimationOptions(duration: 3000, startDelay: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double pageViewHorizontalPadding = (1 - _viewportFraction) * MediaQuery.of(context).size.width / 2;

    return Scaffold(
      body: Stack(
          children: [
            MapWidget(
              key: ValueKey('debug-mapbox-map'),
              styleUri: MapboxStyles.STANDARD,
              onMapCreated: _onMapCreated,
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 150, // Height of the horizontal list area
                child: PageView.builder(
                  controller: _pageController, // Assign the controller
                  itemCount: widget.itinerary.length,
                  scrollDirection: Axis.horizontal,
                  // This callback fires when the page (item) settles after scrolling/snapping
                  onPageChanged: (int index) async {
                    setState(() {
                      _currentPageIndex = index; // Update the current index
                    });

                    _animateMapToCity(widget.itinerary[index], index);
                  },
                  itemBuilder: (context, index) {
                    Neo4jCity selectedCity = widget.itinerary[index];

                    final double horizontalMargin = _viewportFraction < 1.0 ? 8.0 : 0;
                    final bool isOriginCity = index == 0;
                    final Neo4jCity lastCitySelected = isOriginCity ? selectedCity : widget.itinerary[index - 1];

                    return GestureDetector(
                      onTap: () {
                        ref.read(sqlCityProvider.notifier).fetchSqlCity(selectedCity.getId);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CityDetailsScreen(
                                lastCitySelected: lastCitySelected,
                                selectedCity: selectedCity,
                                routesToSelectedCity: lastCitySelected.getRoutes),
                          ),
                        );
                      },
                      child: Container(
                        // Apply margin to create space between the partially visible pages
                        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                        child: Card(
                          elevation: kCardElevation,
                          shape: RoundedRectangleBorder(borderRadius: kCardBorderRadius),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Image.network(
                                  selectedCity.getPrimaryBlobUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity, // Fill the width of the card/page item
                                  // Error handling for image loading
                                  errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.error)),
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.white,

                                  alignment: Alignment.center, // Center the text
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8), // Add some padding for text
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/flags/${selectedCity.getCountry.getName.toLowerCase()}.png', width: 25, height: 25,),
                                          SizedBox(width: 5,),
                                          Text(
                                            selectedCity.getName,
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Container(height: 20, child: VerticalDivider(width: 15, color: Colors.black,)),
                                          Text(
                                              isOriginCity ? 'Origin' :
                                              '${widget.itinerary[index - 1].fetchRoutesForGivenCity(selectedCity.getId).first.getDistance.toInt()} KM'),
                                          VerticalDivider(width: 20, thickness: 5, color: Colors.grey,),
                                          Spacer(),
                                          if (!isOriginCity)
                                            CityScoreChip(score:  widget.itinerary[index - 1].fetchRoutesForGivenCity(selectedCity.getId).first.getScore)

                                        ]
                                      ),
                                    ]
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ]
      ),
    );
  }
}