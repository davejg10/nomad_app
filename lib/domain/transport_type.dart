import 'package:flutter/material.dart';

enum TransportType {
  ALL, BUS, FLIGHT, TAXI, TRAIN, VAN, FERRY, BUS_FERRY, VAN_BUS, VAN_FERRY, BUS_BUS_FERRY, BUS_VAN, FERRY_BUS, FERRY_VAN, BUS_BUS;

  // Helper method to get icon for transport mode
  IconData getIcon() {
    switch (this) {
      case TransportType.ALL:
        return Icons.apps;
      case TransportType.FLIGHT:
        return Icons.airplanemode_active;
      case TransportType.BUS:
        return Icons.directions_bus;
      case TransportType.FERRY:
        return Icons.directions_boat;
      case TransportType.TRAIN:
        return Icons.train;
      case TransportType.VAN:
        return Icons.airport_shuttle;
      default:
        return Icons.emoji_transportation_outlined;
    }
  }

  // Helper method to get color for transport mode
  Color getColor() {
    switch (this) {
      case TransportType.FLIGHT:
        return Colors.blue;
      case TransportType.BUS:
        return Colors.green;
      case TransportType.FERRY:
        return Colors.teal;
      case TransportType.TRAIN:
        return Colors.red;
      case TransportType.VAN:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getTabName() {
    String enumName = this.name;
    if (enumName.contains('_')) {
      return enumName.replaceAll('_', '+');
    }
    return enumName;
  }

  String getName() {
    String enumName = this.name;
    if (enumName.contains('_')) {
      return enumName.replaceAll('_', '  +\n');
    }
    return enumName;
  }
}