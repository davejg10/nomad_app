import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/route_view/route_view_screen.dart';
import 'package:nomad/screens/select_city/providers/providers.dart';

import '../../../domain/neo4j/neo4j_city.dart';

class SelectCityAppBar extends ConsumerWidget implements PreferredSizeWidget{
  const SelectCityAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Neo4jCountry country = ref.read(destinationCountrySelectedProvider)!;
    List<Neo4jCity> itineraryList = ref.watch(itineraryListProvider);
    bool searchBarOpen = ref.watch(searchWidgetVisibility(SearchWidgetIdentifier.SELECT_CITY_SEARCHBAR));

    return AppBar(
      title: Text(
        country.getName,
        style: kAppBarTextStyle,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.undo),
          onPressed: itineraryList.isNotEmpty ? () {
            ref.read(itineraryListProvider.notifier).removeLastFromItinerary();
          } : null,
        ),
        if (searchBarOpen == false)
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              ref.read(searchWidgetVisibility(SearchWidgetIdentifier.SELECT_CITY_SEARCHBAR).notifier).open();
            },
          ),
        IconButton(
          icon: Icon(Icons.task_alt),
          onPressed: itineraryList.isNotEmpty ? () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    RouteViewScreen(),
              ),
            );
          } : null,
        ),
      ],
    );
  }

  // In order to create this wrapper around AppBar and return it to param that is expecting Appbar we have to implement PreferedSizeWidget
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
