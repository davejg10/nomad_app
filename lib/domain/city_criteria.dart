import 'package:flutter/material.dart';

enum CityCriteria {
  SAILING,
  FOOD,
  NIGHTLIFE;

  static Set<String> valuesAsStringSet() {
    return CityCriteria.values.map((cityCriteria) => cityCriteria.name).toSet();
  }

  IconData convertCriteriaToIcon() {
    switch (this) {
      case CityCriteria.SAILING:
        return Icons.sailing;
      case CityCriteria.FOOD:
        return Icons.restaurant;
      case CityCriteria.NIGHTLIFE:
        return Icons.local_bar;
    }
  }


}