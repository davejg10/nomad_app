import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/home/widgets/dropdown_search.dart';
import 'package:nomad/screens/select_city/select_city_screen.dart';

enum DropdownIdentifier { ORIGIN_COUNTRY, ORIGIN_CITY, DESTINATION_COUNTRY }

class HomeScreen extends ConsumerStatefulWidget {
  static Logger _logger = Logger(printer: CustomLogPrinter('home_screen.dart'));

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    ref.watch(originCitySelectedProvider);
    ref.watch(destinationCountrySelectedProvider);
    ref.watch(originCountrySelectedProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/static/gen2.jpg',
            fit: BoxFit.cover,
            // color: Colors.black45,
            colorBlendMode: BlendMode.lighten,
          ),

          // Centered Translucent Card
          Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: _buildDropdownCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCard() {
    return Container(
      key: ValueKey<int>(_currentStep),
      width: 350,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic Title based on current step
          Text(
            getDropdownIdentifierForStep().name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),

          // Dropdown content based on current step
          DropdownSearch(dropdownIdentifier: getDropdownIdentifierForStep()),

          SizedBox(height: 20),

          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button (only show if not on first step)
              if (_currentStep > 0)
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                ),

              // Spacer to push next button to the right
              Spacer(),

              // Next/Continue Button
              _buildNextButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return IconButton(
      icon: Icon(Icons.arrow_forward, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: _isStepValid() ? Colors.deepPurple : Colors.grey,
        shape: CircleBorder(),
      ),
      onPressed: _isStepValid()
          ? () {
        if (_currentStep == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SelectCityScreen(),
            ),
          );
        }
        else {
          setState(() {
            _currentStep++;
          });
        }
      }
          : null,
    );
  }

  bool _isStepValid() {
    switch (_currentStep) {
      case 0:
        return ref.read(originCountrySelectedProvider) != null;
      case 1:
        return ref.read(originCitySelectedProvider) != null;
      case 2:
        return ref.read(destinationCountrySelectedProvider) != null;
      default:
        return false;
    }
  }

  DropdownIdentifier getDropdownIdentifierForStep() {
    switch (_currentStep) {
      case 0:
        return DropdownIdentifier.ORIGIN_COUNTRY;
      case 1:
        return DropdownIdentifier.ORIGIN_CITY;
      case 2:
        return DropdownIdentifier.DESTINATION_COUNTRY;
      default:
        return DropdownIdentifier.ORIGIN_COUNTRY;
    }
  }
}
