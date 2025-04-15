import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/screens/select_city/providers/scrollable_bottom_sheet_position_provider.dart';


class ScrollableBottomSheet extends ConsumerStatefulWidget {
  const ScrollableBottomSheet({
    super.key,
    required this.sheetContent,
  });

  final List<Widget> sheetContent;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScrollableBottomSheetState();
}

class _ScrollableBottomSheetState extends ConsumerState<ScrollableBottomSheet> {
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
    Color sheetLipColor = Theme.of(context).colorScheme.secondary;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color sheetColor = Theme.of(context).colorScheme.surface;

    double sheetPosition = ref.watch(scrollableBottomSheetPositionProvider);
    double minSheetPosition = ref.read(scrollableBottomSheetPositionProvider.notifier).minSheetPosition;
    double maxSheetPosition = ref.read(scrollableBottomSheetPositionProvider.notifier).maxSheetPosition;
    if (sheetPosition > minSheetPosition + 0.02) {
      renderSheetContent = true;
    } else {
      renderSheetContent = false;
    }
    return DraggableScrollableSheet(
      minChildSize: minSheetPosition,
      maxChildSize: maxSheetPosition,
      initialChildSize: sheetPosition,

      builder: (BuildContext context1, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: renderSheetContent ? sheetColor : sheetLipColor,
            borderRadius: kCurvedTopEdges,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 4,
                blurRadius: 10,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: kCardBorderRadius,
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (DragUpdateDetails details) {
                    ref.read(scrollableBottomSheetPositionProvider.notifier).setSheetPosition(details);
                  },
                  onVerticalDragEnd: (DragEndDetails details) {
                    ref.read(scrollableBottomSheetPositionProvider.notifier).setSheetDragEnd(details);

                  },
                  child: Container(
                    color: sheetLipColor,
                    width: double.infinity,
                    child: Icon(
                      size: 30,
                      Icons.drag_handle,
                      color: onSecondary,
                    ),
                  ),
                ),
                if (renderSheetContent)
                  ...[
                    Container(
                      color: Colors.black,
                      width: double.infinity,
                      height: 2,
                    ),
                    Flexible(
                      child: Padding(
                        padding: kSidePadding,
                        child: ListView(
                          children: widget.sheetContent,
                        ),
                      ),
                    )
                  ]
              ],
            ),
          ),
        );
      },
    );
  }
}