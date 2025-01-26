import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/data/destination_respository.dart';

final destinationRepositoryProvider = Provider<DestinationRepository>((ref) {
  return DestinationRepository();
});
