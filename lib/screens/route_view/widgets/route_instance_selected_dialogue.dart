
import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/screens/route_book/route_book_screen.dart';
import 'package:nomad/screens/route_book/widgets/route_instance_card.dart';

Future<bool?> showRouteInstanceSelectedDialogue({
  required BuildContext context,
  required RouteInstance routeInstance,
  required Neo4jCity sourceCity,
  required Neo4jCity targetCity,
  required Set<Neo4jRoute> routes,
  required int itineraryIndex
}) {

  return showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      final theme = Theme.of(dialogContext);

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: kCardBorderRadius,
        ),
        elevation: kCardElevation,
        backgroundColor: theme.dialogBackgroundColor,
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: RouteInstanceCard(
            routeInstance: routeInstance,
            transportType: routeInstance.getTransportType,
            leadingActionText: 'Change',
            leadingActionOnPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RouteBookScreen(
                    sourceCity: sourceCity,
                    targetCity: targetCity,
                    routes: routes,
                    searchDate: routeInstance.getDeparture,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  );
}