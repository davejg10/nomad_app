import 'package:flutter/material.dart';

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