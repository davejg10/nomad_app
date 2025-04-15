import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/providers/travel_preference_provider.dart';

class StyledPreferenceSlider extends ConsumerWidget {
  const StyledPreferenceSlider({
    super.key,
    required this.criteria,
    required this.icon,
  });

  final String criteria;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCostSlider = criteria == 'COST';
    final prefProvider = travelPreferenceProvider(criteria);
    int currentSliderValue = ref.watch(prefProvider);
    int minValue = ref.read(prefProvider.notifier).getMin();
    int midValue = ref.read(prefProvider.notifier).getMid();
    int maxValue = ref.read(prefProvider.notifier).getMax();
    final bool isBalanced = currentSliderValue == midValue && !isCostSlider; // Cost slider might not have a "balanced" state

    Color primarySliderColor = isCostSlider ? Colors.blueGrey : Theme.of(context).colorScheme.secondary;
    Color activeColor = isBalanced ? Colors.grey.shade500 : primarySliderColor;
    Color inactiveColor = Colors.grey.shade300;
    Color thumbColor = isBalanced ? Colors.grey.shade600 : primarySliderColor;

    String valueLabel;
    if (isCostSlider) {
      // Specific labels for cost
      if (currentSliderValue == minValue) valueLabel = "Low Cost Focus";
      else if (currentSliderValue == maxValue) valueLabel = "High Cost OK";
      else valueLabel = "Cost Pref: $currentSliderValue"; // Or Medium
    } else {
      // Generic labels for importance
      if (currentSliderValue == minValue) valueLabel = "Low Importance";
      else if (currentSliderValue == midValue) valueLabel = "Balanced";
      else if (currentSliderValue == maxValue) valueLabel = "High Importance";
      else valueLabel = "Importance: $currentSliderValue";
    }


    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Slider ---
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor,
            inactiveTrackColor: inactiveColor,
            trackHeight: 6.0, // Slightly thicker track
            thumbColor: thumbColor,
            // Use standard thumb or keep custom one if preferred
            // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            thumbShape: _CustomSliderThumbShape(
              // labelText: labelText.substring(0, 3), // Shorten label for thumb?
              labelText: valueLabel, // Show dynamic label on thumb
              isBalanced: isBalanced,
              color: thumbColor,
            ),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
            overlayColor: activeColor.withOpacity(0.15),
            trackShape: const RoundedRectSliderTrackShape(), // Rounded track ends
            // valueIndicatorShape: PaddleSliderValueIndicatorShape(), // Default can be good
            // valueIndicatorColor: activeColor,
            showValueIndicator: ShowValueIndicator.never, // Hide default indicator if thumb shows info
            // valueIndicatorTextStyle: TextStyle(color: Colors.white),
          ),
          child: Slider(
            value: currentSliderValue.toDouble(),
            min: minValue.toDouble(),
            max: maxValue.toDouble(),
            divisions: maxValue - minValue, // Correct divisions calculation
            // label: valueLabel, // Shows on press if showValueIndicator isn't never
            onChanged: (double value) {
              ref.read(prefProvider.notifier).setValue(value.toInt());
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
  final Color color; // Pass the calculated color

  const _CustomSliderThumbShape({
    required this.labelText,
    required this.isBalanced,
    required this.color, // Get color from widget
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    // Adjust size dynamically based on label length? Might be complex. Keep fixed for now.
    // Make it wider to accommodate potentially longer labels like "Balanced"
    return const Size(80, 32); // Wider and slightly taller
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter, // This labelPainter is often for the value indicator, not custom thumb text
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;
    final Size preferredSize = getPreferredSize(true, isDiscrete);

    // Draw the thumb background
    final RRect rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: preferredSize.width * 0.9, height: preferredSize.height * 0.8), // Adjust padding inside shape
      Radius.circular(preferredSize.height / 2), // Rounded pill shape
    );

    final Paint thumbPaint = Paint()
      ..color = color // Use the passed color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rect, thumbPaint);

    // Determine text color based on thumb background luminance
    final Color textColor = color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    // Draw the custom label text
    final TextSpan span = TextSpan(
      text: labelText,
      style: TextStyle(
        fontSize: 10, // Smaller font for potentially longer text inside thumb
        fontWeight: FontWeight.bold,
        color: textColor.withOpacity(0.9), // Slightly transparent?
        // color: Colors.white.withOpacity(isBalanced ? 0.8 : 1.0),
      ),
    );

    final TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1, // Ensure text doesn't wrap
      ellipsis: '...', // Add ellipsis if text is too long
    );

    textPainter.layout(maxWidth: preferredSize.width * 0.8); // Constrain text width slightly less than thumb width
    final Offset textCenter = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    textPainter.paint(canvas, textCenter);
  }
}