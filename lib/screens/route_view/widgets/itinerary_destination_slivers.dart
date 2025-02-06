import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/screens/route_view/widgets/route_illustration.dart';
import 'package:nomad/widgets/city_card.dart';

import '../../../domain/city.dart';

class ItineraryDestinationSlivers extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<RouteEntity> routeList = ref.watch(routeListProvider);
    return SliverList.separated(
        itemCount: routeList.length,
        itemBuilder: (context, index) {
          City city = routeList[index].getTargetCity;
          return Padding(
            padding: kCardPadding,
            child: CityCard(
                key: Key('cityCard${city.getName}'),
                city: city,
                trailingIconButton: IconButton(
                  disabledColor: Colors.grey,
                  icon: const Icon(Symbols.close),
                  onPressed: index == routeList.length - 1  ? () {
                      ref.read(routeListProvider.notifier).removeLastFromItinerary();
                    }
                  : null,
                ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          index = index + 1;
          return RouteIllustration(routeEntity: routeList[index]);
        }
    );
  }
}