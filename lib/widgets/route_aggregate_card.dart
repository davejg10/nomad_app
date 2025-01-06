import 'package:flutter/material.dart';

import '../constants.dart';

class RouteAggregateCard extends StatelessWidget {
  const RouteAggregateCard({
    super.key,
    required this.columnChildren,
    this.boxConstraints = const BoxConstraints(maxHeight: 140, maxWidth: 125),
    this.alignment = Alignment.center
  });

  final List<Widget> columnChildren;
  final BoxConstraints boxConstraints;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: boxConstraints,
        child: Card(
          elevation: kCardElevation,
          child: Padding(
            padding: kCardPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: columnChildren,
            ),
          ),
        ),
      ),
    );
  }
}
