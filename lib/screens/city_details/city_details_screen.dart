import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/screens/city_details/widgets/city_available_routes_card.dart';
import 'package:nomad/screens/city_details/widgets/city_criteria_rankings_card.dart';
import 'package:nomad/screens/city_details/widgets/city_description_card.dart';
import 'package:nomad/screens/city_details/widgets/city_sliver_app_bar.dart';
import 'package:nomad/widgets/generic/screen_scaffold.dart';

import '../../domain/neo4j/neo4j_city.dart';

class CityDetailsScreen extends StatelessWidget {
  const CityDetailsScreen({
    super.key,
    required this.lastCitySelected,
    required this.selectedCity,
  });

  final Neo4jCity lastCitySelected;
  final Neo4jCity selectedCity;

  @override
  Widget build(BuildContext context) {
    bool isOriginCity = lastCitySelected == selectedCity ? true : false;

    return ScreenScaffold(
      padding: EdgeInsets.zero,
      child: CustomScrollView(
        slivers: [
          CitySliverAppBar(
              selectedCity: selectedCity,
          ),
          SliverPadding(
            padding: kSidePadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CityDescriptionCard(
                  selectedCity: selectedCity,
                ),
                CityCriteriaRankingsCard(
                  selectedCity: selectedCity,
                ),
                if (!isOriginCity)
                  CityAvailableRoutesCard(
                    lastCitySelected: lastCitySelected,
                    selectedCity: selectedCity,
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

}
