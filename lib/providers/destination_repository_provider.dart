import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:http/http.dart' as http;

String backendUri = 'http://10.0.2.2:8080';

final destinationRepositoryProvider = Provider<DestinationRepository>((ref) {
  return DestinationRepository(http.Client(), backendUri);
});
