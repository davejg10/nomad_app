import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/screens/city_details/city_details_screen.dart';
import 'package:nomad/screens/city_details/providers/sql_city_provider.dart';
import 'package:nomad/widgets/city_card/city_card_title_row.dart';
import 'package:nomad/widgets/city_card/city_score_chip.dart';

class CityOverlayCard extends ConsumerWidget {
  const CityOverlayCard({
    super.key,
    required this.viewportFraction,
    required this.lastCitySelected,
    required this.selectedCity,
  });
  final double viewportFraction;
  final Neo4jCity lastCitySelected;
  final Neo4jCity selectedCity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double horizontalMargin = viewportFraction < 1.0 ? 8.0 : 0;

    return GestureDetector(
      onTap: () {
        ref.read(sqlCityProvider.notifier).fetchSqlCity(selectedCity.getId);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CityDetailsScreen(
                lastCitySelected: lastCitySelected,
                selectedCity: selectedCity
            ),
          ),
        );
      },
      child: Container(
        // Apply margin to create space between the partially visible pages
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: Card(
          elevation: kCardElevation,
          shape: RoundedRectangleBorder(borderRadius: kCardBorderRadius),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Image.network(
                  selectedCity.getPrimaryBlobUrl,
                  fit: BoxFit.cover,
                  width: double.infinity, // Fill the width of the card/page item
                  // Error handling for image loading
                  errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.error)),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  alignment: Alignment.center, // Center the text
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8), // Add some padding for text
                  child: Column(
                    children: [
                      CityCardTitleRow(
                        lastCitySelected: lastCitySelected,
                        selectedCity: selectedCity,
                      ),
                    ]
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
