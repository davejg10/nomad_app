import 'package:flutter/material.dart';
import 'package:nomad/screens/route_book/widgets/route_instance_card_shimmer.dart';
import 'package:nomad/screens/route_book/widgets/route_instance_loading_indicator.dart';

class RouteInstanceListViewLoading extends StatelessWidget {
  const RouteInstanceListViewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          BelievableLoadingIndicator(),
          RouteInstanceCardShimmer(),
          RouteInstanceCardShimmer(),
          RouteInstanceCardShimmer(),
        ],
      ),
    );
  }
}
