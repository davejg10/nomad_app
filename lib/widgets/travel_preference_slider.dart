import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/travel_preference_provider.dart';

class TravelPreferenceSlider extends ConsumerWidget {
  const TravelPreferenceSlider({
    super.key,
    required this.travelPreference
  });

  final String travelPreference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentSliderValue = ref.watch(travelPreferenceProvider(travelPreference));
    int minValue = ref.read(travelPreferenceProvider(travelPreference).notifier).getMin();
    int midValue = ref.read(travelPreferenceProvider(travelPreference).notifier).getMid();
    int maxValue = ref.read(travelPreferenceProvider(travelPreference).notifier).getMax();
    final bool isBalanced = currentSliderValue == midValue;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(maxValue, (index) {
              final bool isSelected = currentSliderValue == index + 1;
              final bool isMiddleValue = index + 1 == midValue;

              // Determining the color based on position and selection
              Color textColor;
              if (isMiddleValue) {
                textColor = isSelected ? Colors.grey : Colors.grey.shade400;
              } else {
                textColor = isSelected ? Theme.of(context).primaryColor : Colors.grey.shade400;
              }

              return Container(
                width: 30,
                child: Text(
                  '${index + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: textColor,
                  ),
                ),
              );
            }),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: isBalanced ? Colors.grey.shade300 : Theme.of(context).primaryColor,
            inactiveTrackColor: Colors.grey.shade200,
            trackShape: const RectangularSliderTrackShape(),
            trackHeight: 4.0,
            thumbColor: isBalanced ? Colors.grey.shade400 : Theme.of(context).primaryColor,
            thumbShape: _CustomSliderThumbShape(
                labelText: travelPreference,
                isBalanced: isBalanced
            ),
            overlayColor: (isBalanced ? Colors.grey : Theme.of(context).primaryColor).withAlpha(32),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: isBalanced ? Colors.grey.shade400 : Theme.of(context).primaryColor,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
          child: Slider(
            value: currentSliderValue.toDouble(),
            min: minValue.toDouble(),
            max: maxValue.toDouble(),
            divisions: maxValue - 1,
            onChanged: (double value) {
              ref.read(travelPreferenceProvider(travelPreference).notifier).setValue(value.toInt());
            },
          ),
        ),
      ],
    );
  }
}

class _CustomSliderThumbShape extends SliderComponentShape {
  final String labelText;
  final bool isBalanced;

  const _CustomSliderThumbShape({
    required this.labelText,
    required this.isBalanced,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(60, 40);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // Draw the thumb background
    final RRect rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 50, height: 28),
      const Radius.circular(14),
    );

    final Paint thumbPaint = Paint()
      ..color = isBalanced ? Colors.grey.shade400 : sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rect, thumbPaint);

    // Draw the label
    final TextSpan span = TextSpan(
      text: labelText,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(isBalanced ? 0.8 : 1.0),
      ),
    );

    final TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final Offset textCenter = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    textPainter.paint(canvas, textCenter);
  }
}