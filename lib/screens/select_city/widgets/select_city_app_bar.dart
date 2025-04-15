import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/route_view/route_view_screen.dart';

import '../../../domain/neo4j/neo4j_city.dart';

class SelectCityAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SelectCityAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Neo4jCity> itineraryList = ref.watch(itineraryListProvider);
    bool searchBarOpen = ref.watch(widgetVisibilityProvider(WidgetVisibilityProviderIdentifier.SELECT_CITY_SEARCHBAR));
    bool lastCityTileOpen = ref.watch(widgetVisibilityProvider(WidgetVisibilityProviderIdentifier.SELECT_CITY_LAST_CITY_TILE));
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(
              Icons.location_on,
            color: lastCityTileOpen ? Colors.green : null,
          ),
          onPressed: itineraryList.isNotEmpty ? () {
            ref.read(widgetVisibilityProvider(WidgetVisibilityProviderIdentifier.SELECT_CITY_LAST_CITY_TILE).notifier).toggle();
          } : null,
        ),
        if (searchBarOpen == false)
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              ref.read(widgetVisibilityProvider(WidgetVisibilityProviderIdentifier.SELECT_CITY_SEARCHBAR).notifier).open();
            },
          ),
        if (itineraryList.isNotEmpty)
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      RouteViewScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.explore,
                  ),
                  SizedBox(width: 3),
                  Text('View route'),
                ],
              ),
            ),
          )


      ],
    );
  }

  // In order to create this wrapper around AppBar and return it to param that is expecting Appbar we have to implement PreferedSizeWidget
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
