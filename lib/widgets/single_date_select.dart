import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nomad/constants.dart';

class SingleDateSelect extends StatelessWidget {
  const SingleDateSelect({
    super.key,
    required this.onDateSubmitted,
    this.lastDateSelected
  });

  final Function onDateSubmitted;
  final DateTime? lastDateSelected;
  @override
  Widget build(BuildContext context) {
    DateTime initialDate = lastDateSelected ?? DateTime.now();

    return Card(
      shape: const CircleBorder(),
      elevation: kCardElevation,
      color: Colors.deepOrange, // Background color
      child: InkWell(
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime.now().subtract(Duration(days: 15)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (selectedDate != null) {
            onDateSubmitted(selectedDate);
          }
        },
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(12), // Adjust for size
          child: Icon(
            Symbols.calendar_month,
            color: Colors.white, // Icon color
            size: 24,
          ),
        ),
      ),
    );
  }
}
