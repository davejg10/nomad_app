
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/screens/home/select_origin_city_screen.dart';
import 'package:nomad/screens/home/widgets/dropdown_search.dart';

import '../../domain/geo_entity.dart';
import '../../providers/selected_geo_entity_provider.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/screen_scaffold.dart';
import 'home_screen.dart';

class SelectOriginCountryScreen extends ConsumerStatefulWidget {
  const SelectOriginCountryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectOriginCountryScreenState();
}

class _SelectOriginCountryScreenState extends ConsumerState<SelectOriginCountryScreen> {
  int topFlex = 2;
  int bottomFlex = 2;

  bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      backgroundColor: Colors.indigo,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: isKeyboardVisible(context) ? 1 : 2),
            DropdownSearch(
                dropdownIdentifier: DropdownIdentifier.ORIGIN_COUNTRY),
            ElevatedButton(
              onPressed: () {
                GeoEntity? originCountry = ref.read(
                    originCountrySelectedProvider);

                if (originCountry == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackbar('Please select an origin country')
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectOriginCityScreen(),
                    ),
                  );
                }
              },
              child: Text('Start selecting cities'),

            ),
            Spacer(flex: isKeyboardVisible(context) ? 2 : 2)
          ],
        ),
      ),
    );
  }
}