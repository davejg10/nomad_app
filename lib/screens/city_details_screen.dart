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


class CityRating extends StatelessWidget {
  const CityRating({super.key, required this.score, required this.ratingIcon});

  final int score;
  final IconData ratingIcon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
                child: Text(
                  '$score/10',
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.contain,
                child: Icon(ratingIcon),
              ),
            )
          ],
        ),
    );
  }
}