import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/widgets/generic/icon_background_button.dart';

class ActionButtonCard extends StatelessWidget {
  const ActionButtonCard({
    super.key,
    required this.label,
    required this.labelData,
    required this.icon
  });

  final String label;
  final String labelData;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      height: 45,
      width: 160,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: kContainerShape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 12,

                    color: Colors.grey
                ),
              ),
              Text(
                labelData,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          Spacer(),
          IconBackgroundButton(
            icon: icon.icon!,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
