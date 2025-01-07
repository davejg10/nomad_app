import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/route_list_provider.dart';

import '../../../constants.dart';
import '../../../domain/city.dart';

class RouteSummary extends ConsumerWidget {
  RouteSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<City> routeList = ref.watch(routeListProvider);

    return Container(
      alignment: Alignment.topLeft,
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route summary:',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: kFontWeight,
            ),
          ),
          Container(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [Text(
                routeList.map((city) => city.getName).join(' -> '),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.0),
              )],
            ),
          ),
        ],
      ),
    );
  }
}