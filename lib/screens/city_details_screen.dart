import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/screen_scaffold.dart';

import '../domain/city.dart';
import '../widgets/city_rating.dart';

class CityDetailsScreen extends StatelessWidget {
  const CityDetailsScreen({super.key, required this.selectedCity});

  final City selectedCity;

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      appBar: AppBar(
        title: Text(
          selectedCity.getName,
          style: kAppBarTextStyle,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 200,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                          child: Icon(selectedCity.getIcon),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: selectedCity.getCityRatings.entries.map((entry) {
                              return CityRating(score: entry.value, ratingIcon: City.convertCriteriaToIcon(entry.key));
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(selectedCity.getDescription),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
