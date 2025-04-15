import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/screens/city_details/widgets/city_available_routes_card_row.dart';
import 'package:nomad/screens/route_book/providers/route_instance_provider.dart';
import 'package:nomad/screens/route_book/route_book_screen.dart';
import 'package:nomad/screens/route_view/providers/itinerary_index_provider.dart';
import 'package:nomad/widgets/single_date_picker.dart';

class CityAvailableRoutesCard extends ConsumerWidget {
  const CityAvailableRoutesCard({
    super.key,
    required this.lastCitySelected,
    required this.selectedCity,
    required this.routesToSelectedCity

  });
  final Neo4jCity lastCitySelected;
  final Neo4jCity selectedCity;
  final Set<Neo4jRoute> routesToSelectedCity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Card(
      margin: kCardMargin,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: kCardBorderRadius,
      ),
      child: Padding(
        padding: kCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Travel Options',
                  style: kHeaderTextStyle
                ),
                Spacer(),
                SingleDatePicker(
                  onDateSubmitted: (DateTime selectedDate) {
                    ref.read(routeInstanceProvider.notifier).fetchRouteInstance(lastCitySelected, selectedCity, routesToSelectedCity, selectedDate);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RouteBookScreen(
                          sourceCity: lastCitySelected,
                          targetCity: selectedCity,
                          routes: routesToSelectedCity,
                          searchDate: selectedDate,
                        ),
                      ),
                    );
                }),
              ],
            ),
            Divider(),
            Text(
              '${lastCitySelected.getName} -> ${selectedCity.getName}',
              style: kSubHeaderTextStyle,
            ),
            const Text(
              'The following is a list of all transport modes we have in our database and the average cost and duration associated with them.',
              style: kNormalTextStyle,
            ),
            // ListView of travel modes
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: routesToSelectedCity.length,
              itemBuilder: (context, index) {
                final route = routesToSelectedCity.toList()[index];
                return CityAvailableRoutesCardRow(
                  route: route,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
