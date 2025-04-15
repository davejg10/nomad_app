import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/screens/home/providers/selected_countries_provider.dart';
import 'package:nomad/screens/home/widgets/country_select_dropdown.dart';
import 'package:nomad/screens/home/widgets/travel_preferences_dropdown.dart';
import 'package:nomad/screens/select_city/select_city_screen.dart';
import 'package:nomad/widgets/generic/text_background_button.dart';

class ItineraryForm extends ConsumerWidget {
  ItineraryForm({
    super.key
  });
  final _formKey = GlobalKey<FormState>();
  final controller = MultiSelectController<Neo4jCountry>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 4,
            ),
            CountrySelectDropdown(controller: controller),
            const  SizedBox(height: 12,),
            TravelPreferencesDropdown(),
            const SizedBox(height: 12),
            Center(
              child: TextBackgroundButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final selectedCountries = controller.selectedItems.map((item) => item.value).toSet();

                    ref.read(selectedCountryListProvider.notifier).setAll(selectedCountries);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelectCityScreen(),
                      ),
                    );
                  }
                },
                text: 'Select Itinerary',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
