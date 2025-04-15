import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/screens/home/providers/selected_countries_provider.dart';
import 'package:nomad/screens/home/widgets/itinerary_form.dart';
import 'package:nomad/widgets/generic/screen_scaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color surface = Theme.of(context).colorScheme.surfaceContainerHigh;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      color: primary,
                    ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      color: surface,
                    )
                )
              ],
            ),
          ),
          Center(
            child: FittedBox(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: kCardBorderRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ItineraryForm(),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
