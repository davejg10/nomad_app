
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/screens/home/select_destination_country_screen.dart';
import 'package:nomad/screens/home/widgets/dropdown_search.dart';

import '../../domain/geo_entity.dart';
import '../../providers/selected_geo_entity_provider.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/screen_scaffold.dart';
import 'home_screen.dart';

class SelectOriginCityScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ScreenScaffold(
      backgroundColor: Colors.indigo,

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownSearch(dropdownIdentifier: DropdownIdentifier.ORIGIN_CITY),
            ElevatedButton(
              onPressed: () {
                GeoEntity? originCountry = ref.read(originCitySelectedProvider);

                if (originCountry == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackbar('Please select an origin city')
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectDestinationCountryScreen(),
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