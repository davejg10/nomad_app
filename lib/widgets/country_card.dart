import 'package:flutter/material.dart';

import '../domain/country.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({super.key, required this.country, required this.onTap});

  final Country country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Card(
            margin: EdgeInsets.all(0.0),
            shape: ContinuousRectangleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(country.getIcon),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(country.getName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        Text(country.getDescription, overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.black,
          height: 0,
        )
      ],
    );
  }
}
