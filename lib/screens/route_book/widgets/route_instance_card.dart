import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/domain/transport_type.dart';
import 'package:nomad/screens/route_book/route_instance_constants.dart';
import 'package:nomad/widgets/generic/text_background_button.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteInstanceCard extends ConsumerWidget {
  const RouteInstanceCard({
    super.key,
    required this.routeInstance,
    required this.transportType,
    required this.leadingActionText,
    required this.leadingActionOnPressed
  });

  final RouteInstance routeInstance;
  final TransportType transportType;
  final String leadingActionText;
  final VoidCallback leadingActionOnPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    // Format duration
    final hours = routeInstance.getTravelTime.inMinutes ~/ 60;
    final minutes = routeInstance.getTravelTime.inMinutes % 60;
    final durationText = hours > 0
        ? '$hours h ${minutes > 0 ? '$minutes min' : ''}'
        : '$minutes min';

    // Format price
    final currencyFormat = NumberFormat.currency(symbol: '\£');
    final priceText = currencyFormat.format(routeInstance.getCost);

    DateTime routeDeparture = routeInstance.getDeparture;
    DateTime routeArrival = routeInstance.getArrival;

    // Departure and arrival dates/times
    final departureDate = dateFormat.format(routeDeparture);
    final departureTime = timeFormat.format(routeDeparture);
    final arrivalDate = dateFormat.format(routeArrival);
    final arrivalTime = timeFormat.format(routeArrival);

    // Check if departure and arrival are on the same day
    final sameDay = routeDeparture.year == routeArrival.year &&
        routeDeparture.month == routeArrival.month &&
        routeDeparture.day == routeArrival.day;

    return Padding(
      padding: EdgeInsets.all(3),
      child: Card(
        margin: kCardMargin,
        elevation: kCardElevation,
        shape: RoundedRectangleBorder(borderRadius: kCardBorderRadius),
        child: Padding(
          padding: kCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Provider and price row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        routeInstance.getTransportType.getIcon(),
                        color: routeInstance.getTransportType.getColor(),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        routeInstance.getOperator,
                        style: kSubHeaderTextStyle,
                      ),
                    ],
                  ),
                  Chip(
                    shape: kButtonShape,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    label: Text(
                      priceText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(),

              // Departure and arrival info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline column
                  Column(
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        color: routeInstance.getTransportType.getColor(),
                        size: 16,
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: routeInstance.getTransportType.getColor().withOpacity(0.5),
                      ),
                      Icon(
                        Icons.location_on,
                        color: routeInstance.getTransportType.getColor(),
                        size: 16,
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Time and location details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              departureTime,
                              style: kSubHeaderTextStyle,
                            ),
                            Text(
                              departureDate,
                              style: kRouteInstanceCardGreyFont
                            ),
                          ],
                        ),
                        Text(
                          routeInstance.getDepartureLocation,
                          style: kRouteInstanceCardGreyFont,
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              arrivalTime,
                              style: kSubHeaderTextStyle,
                            ),
                            Text(
                              sameDay ? '(Same day)' : arrivalDate,
                              style: kRouteInstanceCardGreyFont,
                            ),
                          ],
                        ),
                        Text(
                          routeInstance.getArrivalLocation,
                          style: kRouteInstanceCardGreyFont,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Duration and details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        durationText,
                        style: kRouteInstanceCardGreyFont,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextBackgroundButton(
                        text: leadingActionText,
                        onPressed: leadingActionOnPressed,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextBackgroundButton(
                        text: 'View',
                        onPressed: () async {
                          final Uri url = Uri.parse(routeInstance.getUrl);
                          if (!await launchUrl(url)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Could not launch booking website'),
                              ),
                            );
                          }
                        },
                        backgroundColor: routeInstance.getTransportType.getColor(),
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
