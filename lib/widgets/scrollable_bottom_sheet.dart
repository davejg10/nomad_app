import 'package:flutter/material.dart';

import '../constants.dart';

class ScrollableBottomSheet extends StatefulWidget {
  ScrollableBottomSheet({
    super.key,
    required this.sheetContent,
    this.sheetColor = Colors.amber,
    this.minSheetPosition = 0.05,
    this.maxSheetPosition = 0.3,
    this.dragSensitivity = 600
  });

  final ListView sheetContent;
  final Color sheetColor;
  final double minSheetPosition;
  final double maxSheetPosition;
  late double sheetPosition = minSheetPosition;
  final double dragSensitivity;

  @override
  State<ScrollableBottomSheet> createState() => _ScrollableBottomSheetState();
}

class _ScrollableBottomSheetState extends State<ScrollableBottomSheet> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: widget.minSheetPosition,
      maxChildSize: widget.maxSheetPosition,
      initialChildSize: widget.sheetPosition,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: kCurvedTopEdges,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 4,
                  blurRadius: 10,
                )
              ]
          ),
          child: Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    // Gives drag animation
                    widget.sheetPosition -= details.delta.dy / widget.dragSensitivity;

                    if (widget.sheetPosition < widget.minSheetPosition) {
                      widget.sheetPosition = widget.minSheetPosition;
                    }
                    // Only let the 30% of the column be covered
                    if (widget.sheetPosition > widget.maxSheetPosition) {
                      widget.sheetPosition = widget.maxSheetPosition;
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Icon(
                        Icons.drag_handle,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: kSidePadding,
                  child: widget.sheetContent
                ),
              )
            ],
          ),
        );
      },
    );
  }
}