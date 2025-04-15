import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/sql/sql_city.dart';
import 'package:nomad/screens/city_details/providers/sql_city_provider.dart';
import 'package:nomad/widgets/shimmer_loading.dart';

class CityDescriptionCard extends ConsumerWidget {
  static Logger _logger = Logger(printer: CustomLogPrinter('city_description_card.dart'));

  const CityDescriptionCard({
    super.key,
    required this.selectedCity
  });

  final Neo4jCity selectedCity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sqlCityState = ref.watch(sqlCityProvider);

    if (sqlCityState.hasValue && sqlCityState.value != null) {
      SqlCity sqlCity = sqlCityState.value!;
      return Card(
        margin: kCardMargin,
        elevation: kCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: kCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About ${selectedCity.getName}',
                style: kHeaderTextStyle,
              ),
              Divider(),
              Text(
                sqlCity.getDescription,
                style: kNormalTextStyle
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: List.generate(4, (index) {
            return  ShimmerLoading(
              child: Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color:  Colors.black,
                ),
              ),
            );
          })
        ),
      );
    }

  }
}
