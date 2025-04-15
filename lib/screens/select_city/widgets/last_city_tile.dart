import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_queried_list_provider.dart';
import 'package:nomad/widgets/city_card.dart';
import 'package:nomad/widgets/generic/add_remove_dialogue.dart';

class LastCityTile extends ConsumerStatefulWidget {
  const LastCityTile({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LastCityTileState();
}

class _LastCityTileState extends ConsumerState<LastCityTile> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    bool lastCityTileOpen = ref.watch(widgetVisibilityProvider(WidgetVisibilityProviderIdentifier.SELECT_CITY_LAST_CITY_TILE));

    return SliverToBoxAdapter(
        child: AnimatedSize(
          duration: kAnimationDuration,
          curve: kAnimationCurve,
          alignment: Alignment.topCenter,
          child: lastCityTileOpen ?
            _buildLastCityTile() :  const SizedBox.shrink(),
        )
    );
  }

  Widget _buildLastCityTile() {
    final itineraryList = ref.read(itineraryListProvider);
    if (itineraryList.isNotEmpty) {
      Neo4jCity lastCitySelected = itineraryList.last;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.green, // Subtle background tint
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(20.0), // Match card radius if any
        ),
        child: CityCard(
          key: Key('cityCard${lastCitySelected.getName}'),
          lastCitySelected: lastCitySelected,
          selectedCity: lastCitySelected,
          routesToSelectedCity: {},
          trailingButton: IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () async {
              final bool? confirmed = await showAddRemoveDialogue(context: context, contextName: lastCitySelected.getName, action: ConfirmationAction.remove, onConfirm: () {});
              if (confirmed == true) {
                ref.read(itineraryListProvider.notifier).removeLastFromItinerary();
                ref.read(widgetVisibilityProvider(WidgetVisibilityProviderIdentifier.SELECT_CITY_LAST_CITY_TILE).notifier).close();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${lastCitySelected.getName} removed from itinerary"), duration: Duration(seconds: 2)),
                );
              }
            },
          ),
        ),
      );
    }
    return SizedBox.shrink();


  }
}