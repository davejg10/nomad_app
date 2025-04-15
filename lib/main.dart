import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nomad/custom_theme.dart';
import 'package:nomad/screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Explicitly get access token
  String accessToken = 'pk.eyJ1IjoiZGF2aWRqZyIsImEiOiJjbTQ4YzVlZ20wZnViMmtzN2t0Y2x3enB0In0.kQCym7r8jYGLD5tUCkVIBg';
  MapboxOptions.setAccessToken(accessToken);

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: CustomTheme.light
    );
  }
}