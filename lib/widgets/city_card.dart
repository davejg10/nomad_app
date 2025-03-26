import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/screens/city_details/city_details_screen.dart';
import 'package:nomad/screens/select_city/widgets/city_criteria_badge.dart';

import '../constants.dart';
import '../domain/city_criteria.dart';
import '../domain/neo4j/neo4j_route.dart';

class CityCard extends ConsumerWidget {
  const CityCard({
    super.key,
    required this.lastCitySelected,
    required this.selectedCity,
    required this.trailingIconButton,
    required this.routesToSelectedCity
  });

  final Neo4jCity lastCitySelected;
  final Neo4jCity selectedCity;
  final Set<Neo4jRoute> routesToSelectedCity;
  final IconButton trailingIconButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CityDetailsScreen(
              lastCitySelected: lastCitySelected,
              selectedCity: selectedCity,
              routesToSelectedCity: routesToSelectedCity
            ),
          ),
        );
      },
      child: Card(
        elevation: kCardElevation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.network(
                    selectedCity.getPrimaryBlobUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: kCardPadding,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selectedCity.getName, style: TextStyle(fontWeight: kFontWeight, fontSize: 18),),
                          if (selectedCity.getCityRatings.isNotEmpty)
                            Row(children: [
                              ...CityCriteria.values.map((criteria) {
                                return CityCriteriaBadge(cityCriteria: criteria, metric: selectedCity.getCityRatings[criteria]!, screen: "SelectCity");
                              }),
                            ],),

                          Text(selectedCity.getShortDescription, ),

                        ],
                      ),
                    ),
                ),
                trailingIconButton
              ],
            )
          ),
        ),
      )

    );
  }
}