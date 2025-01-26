import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/screens/home/providers/queried_country_list_provider.dart';
import 'package:nomad/screens/home/widgets/country_card.dart';

class CountryListView extends ConsumerWidget {
  const CountryListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Country> queriedCountryList = ref.watch(queriedCountryListProvider);
    return ListView.builder(
        itemCount: queriedCountryList.length,
        itemBuilder: (context, index) {
          Country country = queriedCountryList[index];
          return CountryCard(
            key: Key('countryCard${country.getName}'),
            country: country,
          );
        }
    );
  }
}
