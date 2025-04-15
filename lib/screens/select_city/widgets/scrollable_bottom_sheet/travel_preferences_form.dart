import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/providers/travel_preference_provider.dart';
import 'package:nomad/screens/home/providers/origin_cities_provider.dart';
import 'package:nomad/screens/home/widgets/country_select_dropdown.dart';
import 'package:nomad/screens/select_city/providers/available_city_queried_list_provider.dart';
import 'package:nomad/screens/select_city/providers/scrollable_bottom_sheet_position_provider.dart';
import 'package:nomad/screens/select_city/providers/target_cities_given_country_provider.dart';
import 'package:nomad/screens/select_city/widgets/scrollable_bottom_sheet/styled_preference_slider.dart';
import 'package:nomad/screens/select_city/widgets/scrollable_bottom_sheet/travel_preferences_expansion_list.dart';

class TravelPreferencesForm extends ConsumerWidget {
  final controller = MultiSelectController<Neo4jCountry>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
              child: Text(
                'Travel preferences',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            CountrySelectDropdown(controller: controller),
            const SizedBox(height: 12), // Space before button

            TravelPreferencesExpansionList(),

            const SizedBox(height: 32), // Space before button

            // --- Apply Button ---
            Padding( // Add padding around button
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Apply Preferences'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: kButtonShape
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final itineraryList = ref.read(itineraryListProvider);
                      if (itineraryList.isEmpty) {
                        ref.invalidate(originCitiesProvider);
                      } else {
                        ref.read(targetCitiesGivenCountryProvider.notifier)
                            .fetchTargetCities(ref
                            .read(itineraryListProvider)
                            .last);
                      }
                      ref.read(scrollableBottomSheetPositionProvider.notifier)
                          .animateClose();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Preferences updated!"),
                            duration: Duration(seconds: 1)),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16), // Space at the bottom
          ],
        ),
      ),
    );
  }

}