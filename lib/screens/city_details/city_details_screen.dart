import 'package:flutter/material.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/screens/select_city/providers/providers.dart';
import 'package:nomad/widgets/city_criteria_bar.dart';

import '../../domain/neo4j/neo4j_city.dart';
import '../../domain/neo4j/neo4j_route.dart';

class CityDetailsScreen extends StatelessWidget {
  const CityDetailsScreen({
    Key? key,
    required this.lastCitySelected,
    required this.selectedCity,
    required this.routesToSelectedCity
  }) : super(key: key);

  final Neo4jCity lastCitySelected;
  final Neo4jCity selectedCity;
  final Set<Neo4jRoute> routesToSelectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver app bar with city image
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                selectedCity.getPrimaryBlobUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content as a list of cards
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDescriptionCard(),
                _buildRankingsCard(),
                _buildTravelDetailsCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Description Card
  Widget _buildDescriptionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About ${selectedCity.getName}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              selectedCity.getShortDescription,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Rankings Card
  Widget _buildRankingsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'City Rankings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Sailing, Nightlife, Food Rankings
            ...selectedCity.getCityRatings.entries.map((entry) {
              return CityCriteriaBar(
                  cityCriteria: entry.key,
                  metric: entry.value
              );
            }),

          ],
        ),
      ),
    );
  }

  Widget _buildTravelDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Travel Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'The following is a list of all transport modes we have between: ${lastCitySelected.getName} -> ${selectedCity.getName}. Note that the duration and cost listed is an average for all routes of that transport mode we have.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            // ListView of travel modes
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: routesToSelectedCity.length,
              itemBuilder: (context, index) {
                final travelDetail = routesToSelectedCity.toList()[index];
                return _buildTravelModeRow(travelDetail);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Detailed travel mode row
  Widget _buildTravelModeRow(Neo4jRoute route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: route.getTransportType.getColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Transport mode icon
              Container(
                decoration: BoxDecoration(
                  color: route.getTransportType.getColor(),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: Icon(
                  route.getTransportType.getIcon(),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16),

              // Transport mode name
              Expanded(
                flex: 2,
                child: Text(
                  route.getTransportType.getName(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Average duration
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${route.getAverageDuration.inHours} hrs',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Average cost
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(Icons.attach_money, size: 16, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      '£${route.getAverageCost.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data model for city details
class CityDetails {
  final String name;
  final String imageUrl;
  final String description;

  // Rankings
  final int sailingRanking;
  final int nightlifeRanking;
  final int foodRanking;

  // Activities
  final List<String> topActivities;

  // Travel details
  final double averageTravelTime;
  final double averageTravelCost;

  CityDetails({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.sailingRanking,
    required this.nightlifeRanking,
    required this.foodRanking,
    required this.topActivities,
    required this.averageTravelTime,
    required this.averageTravelCost,
  });
}
