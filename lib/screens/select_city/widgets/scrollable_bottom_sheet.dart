import 'package:flutter/material.dart';

import '../../../constants.dart';

class ScrollableBottomSheet extends StatefulWidget {
  ScrollableBottomSheet({
    super.key,
    required this.sheetContent,
    this.minSheetPosition = 0.08,
    this.maxSheetPosition = 0.6,
    this.dragSensitivity = 600
  });

  final List<Widget> sheetContent;
  final double minSheetPosition;
  final double maxSheetPosition;
  final int dragSensitivity;

  @override
  State<ScrollableBottomSheet> createState() => _ScrollableBottomSheetState();
}

class _ScrollableBottomSheetState extends State<ScrollableBottomSheet> {
  late double sheetPosition = widget.minSheetPosition;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Used to disable Listview content before the sheet has been dragged up.
  bool renderSheetContent = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: widget.minSheetPosition,
      maxChildSize: widget.maxSheetPosition,
      initialChildSize: sheetPosition,
      builder: (BuildContext context1, ScrollController scrollController) {
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
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    if (sheetPosition > widget.minSheetPosition) {
                      renderSheetContent = true;
                    }

                    // Gives drag animation
                    sheetPosition -= details.delta.dy / widget.dragSensitivity;

                    if (sheetPosition < widget.minSheetPosition) {
                      sheetPosition = widget.minSheetPosition;
                      renderSheetContent = false;
                    }
                    // Only let the 30% of the column be covered
                    if (sheetPosition > widget.maxSheetPosition) {
                      sheetPosition = widget.maxSheetPosition;
                    }
                  });
                },
                child: const FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(
                    Icons.drag_handle,
                  ),
                ),
              ),
              if (renderSheetContent)
                Flexible(
                  child: Padding(
                    padding: kSidePadding,
                    child: ListView(
                      children: widget.sheetContent,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}