import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';

final loggerProvider = Provider.family<Logger, String>((ref, className) {
  return Logger(printer:CustomLogPrinter(className));
});
