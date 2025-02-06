import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class StateListener<T> {
  List<T> stateChanges = [];

  void call(T? previous, T next) {
    stateChanges.add(next);
  }

  verifyInOrder(List<T> suggested) {
    expect(stateChanges.length, equals(suggested.length), reason: 'The two state lists differ in length');

    for (int i = 0; i < stateChanges.length; i++) {
      expect(stateChanges[i], equals(suggested[i]));
    }
  }

  verifyInOrderAsync<TAsync extends AsyncValue>(List<TAsync> suggested) {
    expect(stateChanges.length, equals(suggested.length), reason: 'The two state lists differ in length');

    for (int i = 0; i < stateChanges.length; i++) {
      (stateChanges[i] as AsyncValue).valueIsEqual(suggested[i]);
    }
  }
}

extension EqualityOperator<T> on AsyncValue {

  void valueIsEqual(AsyncValue<T> passed) {
    if (isLoading) {
      assert(passed.isLoading);
    } else if (hasError) {
      expect(error, equals(passed.error));
    } else if (hasValue) {
      expect(value, equals(passed.value));
    }
  }
}