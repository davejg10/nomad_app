import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/widgets/shimmer_loading.dart';

class RouteInstanceCardShimmer extends StatelessWidget {
  const RouteInstanceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: kCardElevation,
      child: Padding(
        padding: kCardPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ShimmerLoading(
                      child: const Icon(
                        Icons.emoji_transportation_outlined,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ShimmerLoading(
                      child: Container(
                        width: 80,
                        height: 20,
                        decoration: BoxDecoration(
                          color:  Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  label: ShimmerLoading(
                    child: Container(
                      width: 40,
                      height: 20,
                      decoration: BoxDecoration(
                        color:  Colors.black,
                      ),
                    ),
                  )
                ),
              ],
            ),

            const Divider(),

            // Departure and arrival info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline column
                Column(
                  children: [
                    const Icon(
                      Icons.circle_outlined,
                      size: kStandardIconSize,
                    ),
                    Container(
                      width: 2,
                      height: 40,
                      color: Colors.grey,
                    ),
                    const Icon(
                      Icons.location_on,
                      size: kStandardIconSize,
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                // Time and location details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerLoading(
                            child: Container(
                              width: 50,
                              height: 20,
                              decoration: BoxDecoration(
                                color:  Colors.black,
                              ),
                            ),
                          ),
                          ShimmerLoading(
                            child: Container(
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color:  Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      ShimmerLoading(
                        child: Container(
                          width: 120,
                          height: 20,
                          decoration: BoxDecoration(
                            color:  Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerLoading(
                            child: Container(
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color:  Colors.black,
                              ),
                            ),
                          ),
                          ShimmerLoading(
                            child: Container(
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color:  Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      ShimmerLoading(
                        child: Container(
                          width: 120,
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

            const SizedBox(height: 16),

            // Duration and details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: kStandardIconSize,
                    ),
                    const SizedBox(width: 4),
                    ShimmerLoading(
                      child: Container(
                        width: 40,
                        height: 20,
                        decoration: BoxDecoration(
                          color:  Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
            const SizedBox(height: 16),

          ],
        ),
      )
    );
  }
}
