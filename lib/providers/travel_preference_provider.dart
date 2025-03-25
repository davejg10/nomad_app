
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/city_criteria.dart';

import '../custom_log_printer.dart';

final travelPreferenceProvider = NotifierProvider.family<TravelPreferenceNotifier, int, String>(TravelPreferenceNotifier.new);

class TravelPreferenceNotifier extends FamilyNotifier<int, String> {
  late int maxValue;
  late int minValue;
  late int midValue;
  static Logger _logger = Logger(
      printer: CustomLogPrinter('travel_preference_provider.dart'));

  @override
  int build(String preferenceType) {
    ref.keepAlive();
    int startingValue;
    minValue = 1;
    _logger.e(preferenceType);
    if (CityCriteria.valuesAsStringSet().contains(preferenceType.toUpperCase())) {
      maxValue = 5;
    } else {
      maxValue = 3;
    }
    midValue = (maxValue / 2).ceil();
    startingValue = midValue;
    return startingValue;
  }

  void setValue(int newValue) {
    if (newValue < minValue || newValue > maxValue) {
      _logger.w("Travel preference state is min/max bound of: $state");
    } else {
      state = newValue;
    }
  }

  int getMax() {
    return maxValue;
  }

  int getMin() {
    return minValue;
  }

  int getMid() {
    return midValue;
  }
}
