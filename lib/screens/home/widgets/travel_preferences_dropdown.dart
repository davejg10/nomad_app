import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/screens/select_city/widgets/scrollable_bottom_sheet/travel_preferences_expansion_list.dart';
class TravelPreferencesDropdown extends StatefulWidget {
  const TravelPreferencesDropdown({super.key});

  @override
  State<TravelPreferencesDropdown> createState() => _TravelPreferencesDropdownState();
}

class _TravelPreferencesDropdownState extends State<TravelPreferencesDropdown> {

  Icon chevronIcon = Icon(Icons.arrow_drop_down);
  bool showTravelPreferenceSliders = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          chevronIcon = showTravelPreferenceSliders ? Icon(Icons.arrow_drop_down) : Icon(Icons.arrow_drop_up);
          showTravelPreferenceSliders = !showTravelPreferenceSliders;
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Tell us about your preferences',
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              ExpandIcon(
                isExpanded: showTravelPreferenceSliders,
                onPressed: (expanded) {
                  setState(() {
                    showTravelPreferenceSliders = !showTravelPreferenceSliders;
                  });
                }
                ,
              ),

            ],
          ),
          AnimatedSize(
            duration: kAnimationDuration,
            curve: kAnimationCurve,
            alignment: Alignment.topCenter,
            child: showTravelPreferenceSliders ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text('These can be changed later..'),
                  SizedBox(height: 12),

                  TravelPreferencesExpansionList(),
                ],
              ) :  const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
