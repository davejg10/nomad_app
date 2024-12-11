import 'package:flutter/material.dart';

import '../domain/country.dart';

class CountrySearchBar extends StatefulWidget {
  CountrySearchBar({super.key, required this.allCountries});

  List<Country> allCountries;

  @override
  State<CountrySearchBar> createState() => _CountrySearchBarState();
}

class _CountrySearchBarState extends State<CountrySearchBar> {

  late final SearchController _searchController;
  late final FocusNode _focusNode;
  List<Country> filteredCountryList = [];

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
    _focusNode = FocusNode();
    filteredCountryList = widget.allCountries;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _searchController.openView();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      viewConstraints: BoxConstraints(maxHeight: 300),
      viewBuilder: (_) {
        // Constructing the ListView here rather than suggestionBuilder as it allows us to use lazy initialization for the widgets.
        return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: filteredCountryList.length,
            itemBuilder: (context, index) {
              return CountryCard(
                country: filteredCountryList[index],
                onTap: () {
                  //TODO navigator.pushNamed..
                },
              );
            },
          );
      },
      viewOnSubmitted: (userInput) {
        //TODO navigator.pushNamed..
      },
      isFullScreen: false,
      searchController: _searchController,
      viewOnChanged: (userInput) {
        if (userInput.trim().isEmpty) {
          filteredCountryList = List.from(widget.allCountries);
        } else {
          filteredCountryList = widget.allCountries.where((country) => country.getName.contains(userInput)).toList();
        }
      },
      builder: (BuildContext context, SearchController searchController) {
        return SearchBar(
          hintText: 'Search country here...',
          hintStyle: WidgetStateProperty.all(
              TextStyle(
                fontStyle: FontStyle.italic,
              ),
          ),
          autoFocus: true,
          focusNode: _focusNode,
          controller: searchController,
          trailing: const [Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.search),
          )],
          onTap: () {
            searchController.openView();
          },
          onChanged: (_) {
            searchController.openView();
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController searchController) {
        return [Text('Not used - this allows us to provide our own ListView.Builder above for lazy loading...')];
      }
    );
  }
}

class CountryCard extends StatelessWidget {
  const CountryCard({super.key, required this.country, required this.onTap});

  final Country country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Card(
            margin: EdgeInsets.all(0.0),
            shape: ContinuousRectangleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(country.getIcon),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(country.getName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        Text(country.getDescription, overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.black,
          height: 0,
        )
      ],
    );
  }
}

