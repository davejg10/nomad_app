import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/data/backend_respository.dart';
import 'package:http/http.dart' as http;

// String backendUri = 'http://10.0.2.2:8080';
String backendUri = 'http://192.168.4.189:8080';

final backendRepositoryProvider = Provider<BackendRepository>((ref) {
  return BackendRepository(http.Client(), backendUri);
});
