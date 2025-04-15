import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class BelievableLoadingIndicator extends StatefulWidget {
  // Optional list of messages to cycle through
  final List<String>? messages;
  // Estimated total duration - adjust for how long your backend usually takes
  final Duration totalDuration;
  final Color color;
  final double height;

  const BelievableLoadingIndicator({
    super.key,
    this.messages,
    this.totalDuration = const Duration(seconds: 14), // Default duration
    this.color = Colors.blueAccent,
    this.height = 6.0,
  });

  @override
  State<BelievableLoadingIndicator> createState() => _BelievableLoadingIndicatorState();
}

class _BelievableLoadingIndicatorState extends State<BelievableLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progressValue = 0.0;
  String _currentMessage = "";
  int _messageIndex = 0;
  Timer? _messageTimer;

  // Default sophisticated-sounding messages
  static const List<String> _defaultMessages = [
    "Querying transport network providers...",
    "Estimating durations and costs...",
    "Compiling journey options...",
    "Applying user preferences...", // Sounds advanced!
    "Finalizing results..."
  ];

  late List<String> _actualMessages;

  @override
  void initState() {
    super.initState();
    _actualMessages = widget.messages ?? _defaultMessages;
    _currentMessage = _actualMessages.first;

    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    )..addListener(_updateProgress);

    // Start the animation
    _controller.forward();

    // Timer to cycle through messages
    _startMessageTimer();
  }

  void _startMessageTimer() {
    // Calculate interval to roughly match total duration / number of messages
    final messageCount = _actualMessages.length;
    if (messageCount == 0) return; // Important: Avoid division by zero

    // --- CORRECTED LINE ---
    // 1. Get total duration in microseconds (int)
    // 2. Calculate 80% of that value (double)
    // 3. Divide by message count (double)
    // 4. Convert back to Duration, rounding the microseconds value
    final intervalMicroseconds = (widget.totalDuration.inMicroseconds * 0.8) / messageCount;
    final interval = Duration(microseconds: intervalMicroseconds.round());
    // ----------------------

    _messageTimer = Timer.periodic(interval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _messageIndex = (_messageIndex + 1) % _actualMessages.length;
        _currentMessage = _actualMessages[_messageIndex];
      });
      // Stop timer if animation completed (safety check)
      if (!_controller.isAnimating) {
        timer.cancel();
        // Ensure last message is shown if specified
        final lastMessage = _actualMessages.last;
        if (_currentMessage != lastMessage){
          setState(() { _currentMessage = lastMessage; });
        }
      }
    });
  }

  void _updateProgress() {
    if (!mounted) return;
    // --- Non-Linear Progress Simulation ---
    // Uses Sine curve for fast start, slow middle, faster end, hangs near 95%
    final t = _controller.value; // 0.0 to 1.0 linearly over time

    // Simulate stages - Adjust these thresholds and outputs
    double simulatedProgress;
    if (t < 0.3) { // Stage 1: Fast start (0 -> ~0.4)
      simulatedProgress = Curves.easeIn.transform(t / 0.3) * 0.4;
    } else if (t < 0.7) { // Stage 2: Slower middle (~0.4 -> ~0.7)
      // Normalize t for this stage (0 to 1)
      final stageT = (t - 0.3) / (0.7 - 0.3);
      simulatedProgress = 0.4 + Curves.linear.transform(stageT) * 0.3; // Linear within stage
    } else if (t < 0.9) { // Stage 3: Faster again (~0.7 -> ~0.9)
      final stageT = (t - 0.7) / (0.9 - 0.7);
      simulatedProgress = 0.7 + Curves.easeOut.transform(stageT) * 0.2;
    } else { // Stage 4: Hang near the end (~0.9 -> 0.95 slowly)
      final stageT = (t - 0.9) / (1.0 - 0.9);
      simulatedProgress = 0.9 + Curves.easeOut.transform(stageT) * 0.05; // Only increase by 5% max
    }

    // Clamp value just in case
    _progressValue = math.min(simulatedProgress, 0.98); // Never quite reach 1.0 visually

    setState(() {
      // State updated by listener directly changing _progressValue
    });
  }


  @override
  void dispose() {
    _controller.removeListener(_updateProgress); // Clean up listener
    _controller.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add padding so it's not crammed against edges
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take only needed vertical space
        crossAxisAlignment: CrossAxisAlignment.start, // Align text left
        children: [
          // Wrap progress bar in ClipRRect for rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.height / 2),
            child: LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: widget.color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
              minHeight: widget.height,
            ),
          ),
          const SizedBox(height: 8.0),
          // AnimatedSwitcher for smooth text transitions (optional but nice)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
              // Or SlideTransition etc.
            },
            child: Text(
              _currentMessage,
              key: ValueKey<String>(_currentMessage), // Important for AnimatedSwitcher
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8) ?? Colors.black54,
                // fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}