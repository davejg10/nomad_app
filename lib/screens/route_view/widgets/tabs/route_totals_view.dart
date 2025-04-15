import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/screens/city_details/widgets/city_criteria_rankings_card.dart';
import 'package:nomad/widgets/city_criteria_bar.dart';

class RouteTotalsView extends ConsumerWidget {
  const RouteTotalsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CityCriteriaRankingsCard(
              cityCriteriaBars: CityCriteria.values.map((criteria) {
                return CityCriteriaBar(
                  cityCriteria: criteria,
                  metric: ref.read(itineraryListProvider.notifier).calculateCityCriteriaTotal(criteria)
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
