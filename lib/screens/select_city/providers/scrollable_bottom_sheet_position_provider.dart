import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scrollableBottomSheetPositionProvider = NotifierProvider<ScrollableBottomSheetPositionNotifier, double>(ScrollableBottomSheetPositionNotifier.new);

class ScrollableBottomSheetPositionNotifier extends Notifier<double> {

  final double _minSheetPosition = 0.08;
  final double _maxSheetPositon = 0.95;
  final double _dragSensitivity = 600;
  final double _autoThreshold = 0.1;
  double get minSheetPosition => _minSheetPosition;
  double get maxSheetPosition => _maxSheetPositon;
  double get dragSensitivity => _dragSensitivity;

  @override
  double build() {
    ref.keepAlive();
    return minSheetPosition;
  }

  void setSheetPosition(DragUpdateDetails details) {
    state -= details.delta.dy / dragSensitivity;

    if (state < minSheetPosition) {
      state = minSheetPosition;
    }
    if (state > maxSheetPosition) {
      state = maxSheetPosition;
    }
  }

  void setSheetDragEnd(DragEndDetails details) {
    bool isUp = details.primaryVelocity! < 0;
    bool isDown = details.primaryVelocity! > 100;
    if (isUp && state > minSheetPosition + _autoThreshold - 0.05) {
      animateOpen();
    } else if (isDown && state < maxSheetPosition - _autoThreshold) {
      animateClose();
    }
  }

  void animateClose() async {

    final animationValues = generateEaseInOutValues(
      start: state,
      end: minSheetPosition + 0.01,
      frames: 30,
    );
    for (final size in animationValues) {
      state = size;
      await Future.delayed(const Duration(milliseconds: 2)); // ~60fps
    }
  }

  void animateOpen() async {

    final animationValues = generateEaseInOutValues(
      start: state,
      end: maxSheetPosition - 0.01,
      frames: 30,
    );
    for (final size in animationValues) {
      state = size;
      await Future.delayed(const Duration(milliseconds: 2)); // ~60fps
    }
  }

  List<double> generateEaseInOutValues({
    required double start,
    required double end,
    required int frames,
  }) {
    return List.generate(frames, (i) {
      double t = i / (frames - 1); // normalized time
      double easedT = 0.5 * (1 - cos(pi * t)); // cosine ease-in-out
      return start + (end - start) * easedT;
    });
  }



}