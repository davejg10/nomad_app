import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/geo_entity.dart';

import '../../../constants.dart';

class GeoEntityCard extends ConsumerWidget {
  const GeoEntityCard({
    super.key,
    required this.geoEntity,
    required this.cardOnTap
  });

  final GeoEntity geoEntity;
  final void Function(GeoEntity selectedCountry) cardOnTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            cardOnTap(geoEntity);
          },
          child: Padding(
            padding: kCardPadding,
            child: Row(
              children: [
                Icon(geoEntity.getIcon),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(geoEntity.getName, style: const TextStyle(fontWeight: kFontWeight, fontSize: 18),),
                      Text(geoEntity.getDescription, overflow: TextOverflow.ellipsis,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
