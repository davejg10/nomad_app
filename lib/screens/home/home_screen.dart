import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/home/widgets/dropdown_search.dart';
import 'package:nomad/screens/select_city/select_city_screen.dart';
import 'package:nomad/widgets/error_snackbar.dart';
import 'package:nomad/widgets/screen_scaffold.dart';

import '../../domain/geo_entity.dart';

enum DropdownIdentifier { ORIGIN_COUNTRY, ORIGIN_CITY, DESTINATION_COUNTRY }

class HomeScreen extends ConsumerWidget {
  static Logger _logger = Logger(printer: CustomLogPrinter('home_screen.dart'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ScreenScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownSearch(dropdownIdentifier: DropdownIdentifier.ORIGIN_COUNTRY),
            SizedBox(height: 16),
            DropdownSearch(dropdownIdentifier: DropdownIdentifier.ORIGIN_CITY),
            SizedBox(height: 16),
            DropdownSearch(dropdownIdentifier: DropdownIdentifier.DESTINATION_COUNTRY),
            ElevatedButton(
              onPressed: () {
                GeoEntity? originCountry = ref.read(originCountrySelectedProvider);
                GeoEntity? originCity = ref.read(originCitySelectedProvider);
                GeoEntity? destinationCountry = ref.read(destinationCountrySelectedProvider);

                if (originCountry == null || originCity == null || destinationCountry == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackbar('Please select a value for each dropdown')
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectCityScreen(),
                    ),
                  );
                }
              },
              child: Text('Start selecting cities'),
            )
          ],
        ),
      ),
    );
  }
}