import 'package:flutter/material.dart';

import '../domain/city.dart';

class CityCard extends StatelessWidget {
  const CityCard({super.key, required this.city, required this.cardOnTap, required this.arrowIconOnTap});

  final City city;
  final void Function(City selectedCity) cardOnTap;
  final void Function(City selectedCity) arrowIconOnTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        cardOnTap(city);
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(city.getIcon),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(city.getName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(city.getDescription, overflow: TextOverflow.ellipsis,)
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  arrowIconOnTap(city);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}