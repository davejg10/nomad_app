import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/screens/city_details/city_details_screen.dart';
import 'package:nomad/screens/city_details/providers/sql_city_provider.dart';
import 'package:nomad/screens/select_city/widgets/city_card/city_criteria_badge.dart';
import 'package:nomad/widgets/city_card/city_card_title_row.dart';
import 'package:nomad/widgets/city_card/city_score_chip.dart';

import '../../constants.dart';
import '../../domain/city_criteria.dart';
import '../../domain/neo4j/neo4j_route.dart';

class CityCard extends ConsumerWidget {
  const CityCard({
    super.key,
    required this.lastCitySelected,
    required this.selectedCity,
    this.trailingButton,
  });

  final Neo4jCity lastCitySelected;
  final Neo4jCity selectedCity;
  final Widget? trailingButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return InkWell(
        onTap: () {
          ref.read(sqlCityProvider.notifier).fetchSqlCity(selectedCity.getId);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CityDetailsScreen(
                  lastCitySelected: lastCitySelected,
                  selectedCity: selectedCity),
            ),
          );
        },
        child: Card(
          margin: kCardMargin,
          elevation: kCardElevation,
          shape: RoundedRectangleBorder(borderRadius: kCardBorderRadius),
          clipBehavior: Clip.antiAlias,
          child: Container(
              child: Column(
                children: [
                  Image.network(
                    selectedCity.getPrimaryBlobUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250
                  ),
                  Container(
                    width: double.infinity,
                    padding: kCardPadding,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CityCardTitleRow(
                          lastCitySelected: lastCitySelected,
                          selectedCity: selectedCity,
                        ),
                        Divider(),
                        if (selectedCity.getCityRatings.isNotEmpty)
                          Row(children: [
                              ...CityCriteria.values.map((criteria) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CityCriteriaBadge(
                                        cityCriteria: criteria,
                                        metric: selectedCity
                                            .getCityRatings[criteria]!,
                                        screen: "SelectCity"
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        Container(
                          child: Text(
                            selectedCity.getShortDescription,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailingButton ?? SizedBox.shrink()
                ],
              )),
        ));
  }
}
