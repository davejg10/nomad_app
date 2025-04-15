import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor
  });

  Widget child;
  Color? baseColor;
  Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: baseColor ?? Colors.grey.shade300,
        highlightColor: highlightColor ?? Colors.grey.shade100,
        enabled: true,
        child: child
    );
  }
}