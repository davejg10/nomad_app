import 'package:flutter/material.dart';

abstract class GeoEntity {
  String get getId;
  String get getName;
  IconData get getIcon;
  String get getShortDescription;
}