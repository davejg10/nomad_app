import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/screens/home/providers/queried_country_list_provider.dart';
import 'package:nomad/screens/home/widgets/country_card.dart';
import 'package:nomad/screens/home/widgets/country_card_shimmer.dart';

class CountryListView extends ConsumerWidget {
  const CountryListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queriedCountryListProviderState = ref.watch(queriedCountriesListProvider);

    return queriedCountryListProviderState.when(
        data: (countryList) {
          return ListView.builder(
              itemCount: countryList.length,
              itemBuilder: (context, index) {
                Country country = countryList.elementAt(index);
                return CountryCard(
                  key: Key('countryCard${country.getName}'),
                  country: country,
                );
              }
          );
        },
        error: (error, trace) {
          return Container();
        },
        loading: () {
          return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return CountryCardShimmer();
              }
          );
        }
    );

  }
}
