import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/widgets/shimmer_loading.dart';

class CityCardShimmer extends StatelessWidget {
  const CityCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: kCardElevation,
      margin: kCardPadding,
      child: Padding(
        padding: kCardPadding,
        child: Row(
          children: [
            ShimmerLoading(child: Icon(Icons.south_america)),
            SizedBox(width: 12,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading(
                    child: Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                        color:  Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  ShimmerLoading(
                    child: Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color:  Colors.black,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
