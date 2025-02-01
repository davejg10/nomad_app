import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/screens/home/widgets/dropdown_search.dart';
import 'package:nomad/widgets/screen_scaffold.dart';

import '../../providers/search_widget_visibility_provider.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ScreenScaffold(
      child: Center(
        child: Stack(
          children: [
            Positioned(
              top: 100, // Adjust based on your needs
              left: 20,
              right: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownSearch(dropdownIdentifier: SearchWidgetIdentifier.ORIGIN_COUNTRY),
                  SizedBox(height: 16),
                  DropdownSearch(dropdownIdentifier: SearchWidgetIdentifier.ORIGIN_CITY),
                  SizedBox(height: 16),
                  DropdownSearch(dropdownIdentifier: SearchWidgetIdentifier.DESTINATION_COUNTRY),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}