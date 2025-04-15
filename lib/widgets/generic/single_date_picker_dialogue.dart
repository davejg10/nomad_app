import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/screens/route_view/providers/itinerary_index_provider.dart';
import 'package:nomad/screens/route_view/providers/route_list_provider.dart';

Future<DateTime?> showSingleDatePickerDialogue({
  required WidgetRef ref,
  required BuildContext context,
  DateTime? lastDateSelected
}) async {
    int itineraryIndex = ref.read(itineraryIndexProvider);
    DateTime? preSelected;
    DateTime? lowerDateBound = ref.read(routeListProvider.notifier).getRouteDepartLowerBound(itineraryIndex);
    DateTime? higherDateBound = ref.read(routeListProvider.notifier).getRouteDepartUpperBound(itineraryIndex);

    if (lowerDateBound != null) {
      if (higherDateBound != null) {
        int daysBetween = higherDateBound.difference(lowerDateBound).inDays;
        preSelected = lowerDateBound.add(Duration(days: (daysBetween / 2).toInt()));
      } else {
        preSelected = lowerDateBound.add((Duration(days: 1)));
      }
    } else if (higherDateBound != null) {
      preSelected = higherDateBound.subtract(Duration(days: 5));
    } else {
      preSelected = DateTime.now();
    }

    DateTime? selectedDate = await showDatePicker(
      errorInvalidText: 'some error',
      context: context,
      initialDate: lastDateSelected ?? preSelected,
      firstDate: lowerDateBound ?? DateTime.now(),
      lastDate: higherDateBound ?? DateTime.now().add(const Duration(days: 365)),
    );

    return selectedDate;
}