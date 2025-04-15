import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/widgets/city_card/city_score_chip.dart';

class CityCardTitleRow extends StatelessWidget {
  const CityCardTitleRow({
    super.key,
    required this.lastCitySelected,
    required this.selectedCity,
  });
  final Neo4jCity lastCitySelected;
  final Neo4jCity selectedCity;

  @override
  Widget build(BuildContext context) {
    final bool isOriginCity = lastCitySelected == selectedCity;
    final Set<Neo4jRoute> routesToSelectedCity = lastCitySelected.fetchRoutesForGivenCity(selectedCity.getId);

    return Row(
        children: [
          Image.asset('assets/flags/${selectedCity.getCountry.getName.toLowerCase()}.png', width: 25, height: 25,),
          SizedBox(width: 5,),
          Text(
            selectedCity.getName,
            style: kHeaderTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Container(height: 20, child: VerticalDivider(width: 15, color: Colors.black,)),
          Text(
              isOriginCity ? 'Origin' :
              '${routesToSelectedCity.first.getDistance.toInt()} KM'),
          VerticalDivider(width: 20, thickness: 5, color: Colors.grey,),
          Spacer(),
          if (!isOriginCity)
            CityScoreChip(score: routesToSelectedCity.first.getScore)
        ]
    );
  }
}
