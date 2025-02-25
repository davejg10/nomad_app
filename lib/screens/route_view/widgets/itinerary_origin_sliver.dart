import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/route_view/widgets/route_illustration.dart';

import '../../../widgets/city_card.dart';

class ItineraryOriginSliver extends ConsumerWidget {
  const ItineraryOriginSliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    City originCity = ref.read(originCitySelectedProvider)!;
    final routeList = ref.watch(routeListProvider);
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: kCardPadding,
            child: CityCard(
              key: Key('cityCard${originCity.getName}'),
              city: originCity,
              trailingIconButton: IconButton(
                icon: const Icon(Symbols.home),
                onPressed:  () {
                }
              ),
            ),
          ),
          if (routeList.isNotEmpty)
            RouteIllustration(routeEntity: routeList[0])
        ]
      ),
    );
  }
}
