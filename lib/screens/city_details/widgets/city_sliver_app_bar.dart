import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/screens/map_view/map_view_screen.dart';
import 'package:nomad/screens/route_view/providers/route_list_provider.dart';
import 'package:nomad/widgets/generic/icon_background_button.dart';

class CitySliverAppBar extends ConsumerWidget {
  const CitySliverAppBar({
    super.key,
    required this.selectedCity,
  });

  final Neo4jCity selectedCity;

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
                  itinerary: [selectedCity],
                  routeList: ref.read(routeListProvider),
                ),
              ),
            );
          },
        ),
      ],
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          selectedCity.getPrimaryBlobUrl,
          fit: BoxFit.cover,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: kCurvedTopEdges,
            color: canvasColor,
          ),
        ),
      ),
    );
  }
}
