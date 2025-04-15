import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nomad/domain/transport_type.dart';

const List<String> kRouteInstanceFilter = [
  'Price: Low to High',
  'Price: High to Low',
  'Duration: Shortest',
  'Departure: Earliest',
  'Departure: Latest',
  'Arrival: Earliest',
  'Arrival: Latest',
];

const kRouteInstanceTabOrder = [
  TransportType.ALL,
  TransportType.FLIGHT,
  TransportType.TRAIN,
  TransportType.BUS,
  TransportType.FERRY,
  TransportType.VAN,
];

var kRouteInstanceCardGreyFont = TextStyle(
  color: Colors.grey[600],
  fontSize: 14,
);

