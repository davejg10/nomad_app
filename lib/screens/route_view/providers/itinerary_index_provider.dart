import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';

final itineraryIndexProvider = StateProvider<int>((ref)  {
  final itineraryList = ref.watch(itineraryListProvider);
  return itineraryList.length;
});