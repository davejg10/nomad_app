import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nomad/widgets/screen_scaffold.dart';

import '../../domain/neo4j/neo4j_city.dart';
import 'mapbox_utils.dart';

class MapViewScreen extends StatefulWidget {
  MapViewScreen({
    super.key,
    required this.originCity,
    required this.itinerary
  });

  final Neo4jCity originCity;
  final List<Neo4jCity> itinerary;

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  String _mapLoadStatus = 'Initializing...';
  MapboxMap? _mapboxMap;
  Position cameraPosition = Position.named(lat: 51.5072, lng: 0.1276);

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MapWidget(
      key: ValueKey('debug-mapbox-map'),
      styleUri: MapboxStyles.STANDARD,
      // cameraOptions: CameraOptions(
      //     center: Point(coordinates: Position.named(lat: widget.originCity.getCoordinates.getLongitude, lng: widget.originCity.getCoordinates.getLatitude)),
      //     zoom: 2.0,
      //     bearing: 0.0,
      //     pitch: 0.0
      // ),
      onMapCreated: _onMapCreated,
    );
  }


  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapLoadStatus = 'Map Created';
    this._mapboxMap = mapboxMap;
    await MapboxUtils.placeMarker(_mapboxMap!, city: widget.originCity);
    widget.itinerary.forEach((city) async => await MapboxUtils.placeMarker(_mapboxMap!, city: city));
    for (int i = 1; i < widget.itinerary.length; i++) {
      if (i == 1) {
        await MapboxUtils.createPolyline(mapboxMap, sourceCity: widget.originCity, targetCity: widget.itinerary[i - 1]);
      }
      await MapboxUtils.createPolyline(mapboxMap, sourceCity: widget.itinerary[i - 1], targetCity: widget.itinerary[i]);
    }
    await _mapboxMap!.flyTo(
        CameraOptions(
            center: Point(coordinates: Position.named(lat: widget.originCity.getCoordinates.getLongitude, lng: widget.originCity.getCoordinates.getLatitude)),
            anchor: ScreenCoordinate(x: 34.43, y: 53.43),
            zoom: 6,
            pitch: 30),
        MapAnimationOptions(duration: 4000, startDelay: 1000));
    setState(() {

    });
    print('Mapbox Map Created Successfully');
  }

}