import 'package:flutter/material.dart';
import 'package:nomad/widgets/shimmer_loading.dart';

class RouteBookTabBarShimmer extends StatelessWidget {
  const RouteBookTabBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerLoading(
            child: const SizedBox(
              height: 40,
              child: const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  Icons.emoji_transportation_outlined,

                ),
              ),
            )
        ),
        ShimmerLoading(
            child: Container(
              width: 60,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white, // Base color needs to be non-transparent
              ),
            )
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}
