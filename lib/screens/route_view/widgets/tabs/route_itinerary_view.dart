import 'package:flutter/material.dart';

import '../itinerary_destination_slivers.dart';
class RouteItineraryView extends StatelessWidget {
  const RouteItineraryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        ItineraryDestinationSlivers(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30.0),
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
