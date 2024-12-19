import 'package:flutter/material.dart';

import '../constants.dart';

class ScrollableBottomSheet extends StatefulWidget {
  ScrollableBottomSheet({
    super.key,
    required this.sheetContent,
    this.minSheetPosition = 0.05,
    this.maxSheetPosition = 0.3,
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

  bool disableContentScroll = true;

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
              ]
          ),
          child: Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    // Solves the issue of accidentally scrolling Listview instead of dragging handle.
                    if (sheetPosition > widget.minSheetPosition) {
                      disableContentScroll = false;
                    }
                    // Gives drag animation
                    sheetPosition -= details.delta.dy / widget.dragSensitivity;

                    if (sheetPosition < widget.minSheetPosition) {
                      sheetPosition = widget.minSheetPosition;
                      disableContentScroll = true;
                    }
                    // Only let the 30% of the column be covered
                    if (sheetPosition > widget.maxSheetPosition) {
                      sheetPosition = widget.maxSheetPosition;
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
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: kSidePadding,
                  child: ListView(
                    physics: disableContentScroll ? NeverScrollableScrollPhysics() : null,
                    children: widget.sheetContent,
                  )
                ),
              )
            ],
          ),
        );
      },
    );
  }
}