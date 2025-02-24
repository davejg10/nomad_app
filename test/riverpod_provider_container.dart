import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

// Taken from the official Riverpod testing documentation.
// A testing utility which creates a [ProviderContainer] and automatically
// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}