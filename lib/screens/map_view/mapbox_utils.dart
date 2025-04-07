import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../domain/neo4j/neo4j_city.dart';

class MapboxUtils {

  static Future<void> placeMarker(MapboxMap mapboxMap, { required Neo4jCity city }) async {
    Uint8List wayPointImage = await MapboxUtils.loadWayPointImageNetwork(city.getPrimaryBlobUrl);
    wayPointImage = await MapboxUtils.makeImageCircular(wayPointImage);
    // Uint8List wayPointImage = await MapboxUtils.loadWayPointImage('assets/static/pin_drop.png');
    PointAnnotationManager pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();

    PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
        geometry: Point(coordinates: Position.named(lat: city.getCoordinates.getLongitude, lng: city.getCoordinates.getLatitude)),
        image: wayPointImage,
        iconSize: 1.0,
        iconColor: 000000
    );

    // Add the annotation to the map
    pointAnnotationManager.create(pointAnnotationOptions);
  }

  static Future<void> createPolyline(MapboxMap mapboxMap, { required Neo4jCity sourceCity, required Neo4jCity targetCity}) async {

    PolylineAnnotationManager polylineAnnotationManager = await mapboxMap.annotations.createPolylineAnnotationManager();

    // Step 2: Define the coordinates for the polyline
    List<Point> polylineCoordinates = [
      Point(coordinates: Position.named(lat: sourceCity.getCoordinates.getLongitude, lng: sourceCity.getCoordinates.getLatitude)),
      Point(coordinates: Position.named(lat: targetCity.getCoordinates.getLongitude, lng: targetCity.getCoordinates.getLatitude)),
    ];

    // Step 3: Add the polyline to the map
    polylineAnnotationManager.create(PolylineAnnotationOptions(
      geometry: LineString.fromPoints(points: polylineCoordinates),
      // lineWidth: 4.0,
      // lineOpacity: 0.8,
    ));
  }

  static Future loadWayPointImage(String assetPath) async {
    final ByteData bytes = await rootBundle.load(assetPath);
    return bytes.buffer.asUint8List();
  }

  static Future<Uint8List> loadWayPointImageNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to load network image");
    }
  }

  static Future<Uint8List> makeImageCircular(Uint8List imageData, {int size = 100}) async {
    ui.Codec codec = await ui.instantiateImageCodec(imageData, targetWidth: size, targetHeight: size);
    ui.FrameInfo frame = await codec.getNextFrame();
    ui.Image image = frame.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..isAntiAlias = true;

    final double radius = size / 2;
    final Rect rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());
    final RRect roundedRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // Clip to a circle
    canvas.clipRRect(roundedRect);
    canvas.drawImage(image, Offset.zero, paint);

    final ui.Image roundedImage = await recorder.endRecording().toImage(size, size);
    final ByteData? byteData = await roundedImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }


}