import 'package:flutter/material.dart';

abstract class GeoEntity {
  String get getId;
  String get getName;
  String get getDescription;
  IconData get getIcon;
}