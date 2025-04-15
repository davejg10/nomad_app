import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/screens/city_details/city_details_screen.dart';
import 'package:nomad/screens/city_details/providers/sql_city_provider.dart';
import 'package:nomad/screens/map_view/widgets/city_overlay_page_view.dart';
import 'package:nomad/widgets/city_card/city_score_chip.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _mapboxMap?.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    setState(() {
      _mapboxMap = mapboxMap;

    });
    if (widget.itinerary.isNotEmpty) {
      widget.itinerary.forEach((city) async => await MapboxUtils.placeMarker(_mapboxMap!, city: city));
      // Fly to the initial city (or originCity if you prefer)
      MapboxUtils.animateMapToCity(mapboxMap, widget.itinerary, widget.routeList, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: CityOverlayPageView(
                  itinerary: widget.itinerary,
                  routeList: widget.routeList,
                  mapboxMap: _mapboxMap,
                )
              ),
            )
          ]
      ),
    );
  }
}