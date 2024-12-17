import 'package:flutter/material.dart';

import '../domain/city.dart';
import '../widgets/page_title.dart';

class CityDetailsScreen extends StatelessWidget {
  const CityDetailsScreen({super.key, required this.selectedCity});

  final City selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageTitle(
              titleText: selectedCity.getName,
            ),
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
                              children: [
                                CityRating(
                                  score: 9,
                                  ratingIcon: Icons.sailing,
                                ),
                                CityRating(
                                  score: 9,
                                  ratingIcon: Icons.restaurant,
                                ),
                                CityRating(
                                  score: 9,
                                  ratingIcon: Icons.local_bar,
                                )
                              ],
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
        ),
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

