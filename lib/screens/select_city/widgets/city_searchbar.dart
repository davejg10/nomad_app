import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/select_city/providers/providers.dart';
import 'package:nomad/widgets/error_snackbar.dart';

class CitySearchbar extends ConsumerStatefulWidget {
  const CitySearchbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CitySearchbarState();
}

class _CitySearchbarState extends ConsumerState<CitySearchbar> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void closeSearchBar() {
    _searchController.text = '';
    ref.read(searchWidgetVisibility(SearchWidgetIdentifier.SELECT_CITY_SEARCHBAR).notifier).close();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      onSubmitted: (userInput) {
        Neo4jCity? submittedCity = ref.read(availableCityQueriedListProvider.notifier).submit(userInput);

        if (submittedCity != null) {
          closeSearchBar();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackbar('$userInput is not a valid city in this list...')
          );
        }
      },
      onChanged: (userInput) {
        ref.read(availableCityQueriedListProvider.notifier).filter(userInput);
      },
      controller: _searchController,
      autoFocus: true,
      hintText: 'Search cities...',
      leading: Icon(Icons.search),
      trailing: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            ref.read(availableCityQueriedListProvider.notifier).reset();
            closeSearchBar();
          },
        ),
      ]
    );
  }
}
