import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/screens/map_view/map_view_screen.dart';
import 'package:nomad/screens/route_view/providers/route_list_provider.dart';
import 'package:nomad/widgets/generic/icon_background_button.dart';

import 'package:flutter/material.dart';

class RouteViewAppBar extends ConsumerWidget {
  const RouteViewAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color canvasColor = Theme.of(context).colorScheme.surfaceContainerHigh;
    Color iconButtonColor = Theme.of(context).colorScheme.onSecondary;
    return SliverAppBar(
      leading: IconBackgroundButton(
        icon: Icons.arrow_back,
        iconColor: iconButtonColor,
        padding: const EdgeInsets.only(left: 8.0),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconBackgroundButton(
          icon: Icons.public,
          iconColor: iconButtonColor,

          padding: const EdgeInsets.only(right: 16.0),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MapViewScreen(
                  itinerary: ref.read(itineraryListProvider),
                  routeList: ref.read(routeListProvider),
                ),
              ),
            );
          },
        ),
      ],
      expandedHeight: 300.0,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          'https://st-glb-uks-devopsutils.azureedge.net/images/thailand.webp',
          fit: BoxFit.cover,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: Column(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: kCurvedTopEdges,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
