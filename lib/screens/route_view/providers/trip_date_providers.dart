import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripDateStartProvider = StateProvider<DateTime?>((ref) => DateTime(2025, 4, 16));
final tripDateFinishProvider = StateProvider<DateTime?>((ref) => DateTime(2025, 4, 25));