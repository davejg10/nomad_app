import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/route_view/route_view_screen.dart';

class SelectCityAppBar extends ConsumerWidget implements PreferredSizeWidget{
  const SelectCityAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Country country = ref.read(destinationCountrySelectedProvider)!;
    List<RouteEntity> routeList = ref.watch(routeListProvider);
    bool searchBarOpen = ref.watch(searchWidgetVisibility(SearchWidgetIdentifier.SELECT_CITY_SEARCHBAR));

    return AppBar(
      title: Text(
        country.getName,
        style: kAppBarTextStyle,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.undo),
          onPressed: routeList.isNotEmpty ? () {
            ref.read(routeListProvider.notifier).removeLastFromItinerary();
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
          onPressed: routeList.isNotEmpty ? () {
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
