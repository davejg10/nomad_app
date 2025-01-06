import 'package:flutter/material.dart';

import '../constants.dart';

class CityRating extends StatelessWidget {
  const CityRating({super.key, required this.score, required this.ratingIcon});

  final double score;
  final IconData ratingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.centerRight,
            child: Text(
              '$score/10',
              style: const TextStyle(
                fontWeight: kFontWeight,
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
    );
  }
}