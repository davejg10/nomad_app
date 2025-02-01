import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/destination.dart';

import '../../../constants.dart';

class DestinationCard extends ConsumerWidget {
  const DestinationCard({
    super.key,
    required this.destination,
    required this.cardOnTap
  });

  final Destination destination;
  final void Function(Destination selectedCountry) cardOnTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            cardOnTap(destination);
          },
          child: Card(
            elevation: kCardElevation,
            margin: kCardPadding,
            child: Padding(
              padding: kCardPadding,
              child: Row(
                children: [
                  Icon(destination.getIcon),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(destination.getName, style: const TextStyle(fontWeight: kFontWeight, fontSize: 18),),
                        Text(destination.getDescription, overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
