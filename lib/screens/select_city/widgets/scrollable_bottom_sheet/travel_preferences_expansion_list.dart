import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/providers/travel_preference_provider.dart';
import 'package:nomad/screens/select_city/widgets/scrollable_bottom_sheet/styled_preference_slider.dart';

class TravelPreferencesExpansionList extends ConsumerStatefulWidget {
  const TravelPreferencesExpansionList({super.key});

  @override
  ConsumerState<TravelPreferencesExpansionList> createState() => _ExpansionPanelListState();
}

class _ExpansionPanelListState extends ConsumerState<TravelPreferencesExpansionList> {
  late List<bool> _isExpanded;
  final String costCriteria = 'COST';

  final List<String> allCriteria = [...CityCriteria.valuesAsStringSet().toList(), 'COST'];

  @override
  void initState() {
    super.initState();
    // Initialize the list with all panels closed
    _isExpanded = List<bool>.filled(allCriteria.length, false);
  }

  String _getValueLabel(String criteria, int currentValue) {
    final prefProvider = travelPreferenceProvider(criteria);
    int minValue = ref.read(prefProvider.notifier).getMin();
    int midValue = ref.read(prefProvider.notifier).getMid();
    int maxValue = ref.read(prefProvider.notifier).getMax();
    bool isCostSlider = criteria == costCriteria;

    if (isCostSlider) {
      if (currentValue == minValue) return "Low Cost Focus";
      if (currentValue == maxValue) return "High Cost OK";
      return "Medium Cost";
    } else {
      if (currentValue == minValue) return "Low Importance";
      if (currentValue == midValue) return "Balanced";
      if (currentValue == maxValue) return "High Importance";
      return "Importance: $currentValue"; // Fallback
    }
  }

  String _formatCriteriaName(String name) {
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  IconData _getIconForCriteria(String criteria) {
    if (criteria == 'COST') {
      return Icons.attach_money;
    }
    return CityCriteria.values.firstWhere((e) => e.name == criteria).convertCriteriaToIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: kCardBorderRadius,

        // borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey),
      ),
      child: ClipRRect(
        borderRadius: kCardBorderRadius,

        child: ExpansionPanelList(
          materialGapSize: 0,
          // Controls the expansion animation duration
          animationDuration: kAnimationDuration,
          // Callback when a panel header is tapped
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              // Toggle the expanded state for the tapped panel
              for (int i = 0; i<allCriteria.length; i++) {
                if (i == index) {
                  _isExpanded[index] = isExpanded;
                  continue;
                }
                _isExpanded[i] = false;
              }
            });
          },
          elevation: 3,
          dividerColor: Colors.grey.shade300,
          children: List.generate(allCriteria.length, (index) {
            final criteria = allCriteria[index];
            final currentValue = ref.watch(travelPreferenceProvider(criteria));
            bool isDefaultValue = currentValue == ref.read(travelPreferenceProvider(criteria).notifier).midValue;
            return ExpansionPanel(
              // Header shown when collapsed
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  leading: Icon(
                    _getIconForCriteria(criteria),
                    color: isDefaultValue ?  Colors.grey.shade600 : Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    _formatCriteriaName(criteria), // Your helper function
                    style: TextStyle(
                        fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16
                    ),
                  ),
                  trailing: Text(
                    _getValueLabel(criteria, currentValue),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                );
              },
              // Body shown when expanded (Your Slider Widget)
              body: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0, top: 0), // Padding around the slider
                child: StyledPreferenceSlider(
                  criteria: criteria,
                  icon: _getIconForCriteria(criteria), // Icon might be redundant here if header shows it
                ),
              ),
              // Current expansion state for this panel
              isExpanded: _isExpanded[index],
              // Allow tapping the header to expand/collapse
              canTapOnHeader: true,
            );
          }
          ), // End of List.generate
        ),
      ),
    ); // End ExpansionPanelList;
  }
}
