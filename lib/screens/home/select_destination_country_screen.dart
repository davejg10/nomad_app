
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/screens/home/widgets/dropdown_search.dart';

import '../../domain/geo_entity.dart';
import '../../providers/selected_geo_entity_provider.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/screen_scaffold.dart';
import '../select_city/select_city_screen.dart';
import 'home_screen.dart';

class SelectDestinationCountryScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ScreenScaffold(
      backgroundColor: Colors.indigo,

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownSearch(dropdownIdentifier: DropdownIdentifier.DESTINATION_COUNTRY),
            ElevatedButton(
              onPressed: () {
                GeoEntity? originCountry = ref.read(destinationCountrySelectedProvider);

                if (originCountry == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackbar('Please select an origin country')
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