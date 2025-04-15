import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nomad/constants.dart';

import 'generic/single_date_picker_dialogue.dart';

class SingleDatePicker extends ConsumerWidget {
  const SingleDatePicker({
    super.key,
    required this.onDateSubmitted,
    this.lastDateSelected,
  });

  final Function onDateSubmitted;
  final DateTime? lastDateSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Card(
      elevation: kIconButtonElevation,
      shape: kButtonShape,
      color: Theme.of(context).primaryColor,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          DateTime? selectedDate = await showSingleDatePickerDialogue(ref: ref, context: context, );
          if (selectedDate != null) {
            onDateSubmitted(selectedDate);
          }
        },
        icon: const Icon(
          Symbols.calendar_month,
          color: Colors.white, // Icon color
          size: 24,
        ),
      ),
    );
  }
}
