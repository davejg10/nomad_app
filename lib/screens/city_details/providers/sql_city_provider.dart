import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/sql/sql_city.dart';
import 'package:nomad/providers/repository_providers.dart';

final sqlCityProvider = AsyncNotifierProvider<SqlCityNotifier, SqlCity?>(
      () => SqlCityNotifier(),
);

class SqlCityNotifier extends AsyncNotifier<SqlCity?> {
  static Logger _logger = Logger(printer: CustomLogPrinter('sql_city_provider.dart'));

  @override
  FutureOr<SqlCity>? build() {
    return null;
  }

  Future<void> fetchSqlCity(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(cityRepositoryProvider).findSqlCityById(id));
  }

}