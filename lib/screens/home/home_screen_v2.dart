import 'package:flutter/material.dart';

class TravelSelectionPage extends StatefulWidget {
  @override
  _TravelSelectionPageState createState() => _TravelSelectionPageState();
}

class _TravelSelectionPageState extends State<TravelSelectionPage> {
  // Mock data
  final List<Map<String, String>> countries = [
    {'id': 'us', 'name': 'United States'},
    {'id': 'fr', 'name': 'France'},
    {'id': 'jp', 'name': 'Japan'},
  ];

  final Map<String, List<Map<String, String>>> cities = {
    'us': [
      {'id': 'nyc', 'name': 'New York City'},
      {'id': 'sf', 'name': 'San Francisco'},
      {'id': 'la', 'name': 'Los Angeles'},
    ],
    'fr': [
      {'id': 'paris', 'name': 'Paris'},
      {'id': 'nice', 'name': 'Nice'},
      {'id': 'lyon', 'name': 'Lyon'},
    ],
    'jp': [
      {'id': 'tokyo', 'name': 'Tokyo'},
      {'id': 'osaka', 'name': 'Osaka'},
      {'id': 'kyoto', 'name': 'Kyoto'},
    ],
  };

  // State variables
  int _currentStep = 0;
  Map<String, String>? selectedHomeCountry;
  Map<String, String>? selectedHomeCity;
  Map<String, String>? selectedDestinationCountry;

  // Animation controller for next button
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/static/generic_background.jpg',
            fit: BoxFit.cover,
            color: Colors.black45,
            colorBlendMode: BlendMode.darken,
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
            _getTitleForStep(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),

          // Dropdown content based on current step
          _buildDropdownForStep(),

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

  Widget _buildDropdownForStep() {
    switch (_currentStep) {
      case 0:
        return DropdownButtonFormField<Map<String, String>>(
          value: selectedHomeCountry,
          hint: Text('Select Home Country'),
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          items: countries.map((country) {
            return DropdownMenuItem(
              value: country,
              child: Text(country['name']!),
            );
          }).toList(),
          onChanged: (country) {
            setState(() {
              selectedHomeCountry = country;
            });
          },
        );

      case 1:
        return DropdownButtonFormField<Map<String, String>>(
          value: selectedHomeCity,
          hint: Text('Select Home City'),
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          items: cities[selectedHomeCountry!['id']]!.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city['name']!),
            );
          }).toList(),
          onChanged: (city) {
            setState(() {
              selectedHomeCity = city;
            });
          },
        );

      case 2:
        return DropdownButtonFormField<Map<String, String>>(
          value: selectedDestinationCountry,
          hint: Text('Select Destination Country'),
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          items: countries
              .where((country) => country['id'] != selectedHomeCountry!['id'])
              .map((country) {
            return DropdownMenuItem(
              value: country,
              child: Text(country['name']!),
            );
          }).toList(),
          onChanged: (country) {
            setState(() {
              selectedDestinationCountry = country;
            });
          },
        );

      default:
        return Container();
    }
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
        setState(() {
          _currentStep++;
        });
      }
          : null,
    );
  }

  String _getTitleForStep() {
    switch (_currentStep) {
      case 0:
        return 'Choose Home Country';
      case 1:
        return 'Select Home City';
      case 2:
        return 'Pick Destination Country';
      default:
        return '';
    }
  }

  bool _isStepValid() {
    switch (_currentStep) {
      case 0:
        return selectedHomeCountry != null;
      case 1:
        return selectedHomeCity != null;
      case 2:
        return selectedDestinationCountry != null;
      default:
        return false;
    }
  }
}