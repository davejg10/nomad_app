import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/screens/select_city/providers/providers.dart';
import 'package:nomad/screens/select_city/providers/target_cities_given_country_provider.dart';

import '../../../custom_log_printer.dart';
import '../../../domain/neo4j/neo4j_city.dart';
import '../../../providers/itinerary_list_provider.dart';

class AddToItineraryDialogue extends ConsumerWidget {
  const AddToItineraryDialogue({
    super.key,
    required this.selectedCity
  });

  final Neo4jCity selectedCity;
  static Logger _logger = Logger(printer: CustomLogPrinter('add_to_itinerary_diaglogue.dart'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SimpleDialog(
      title: const Text('Choose your desired route'),
      children: <Widget>[
          SimpleDialogOption(
            onPressed: () async {
              ref.read(itineraryListProvider.notifier).addToItinerary(selectedCity);
              Navigator.pop(context);
            },
            child: Text('Add to itinerary')
          ),

      ],

    );
  }
}
