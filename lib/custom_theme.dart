// This theme was generated using https://rydmike.com/flexcolorscheme/themesplayground-latest/

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.2.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class CustomTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Playground built-in scheme made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFF00296B),
      primaryContainer: Color(0xFFA0C2ED),
      secondary: Color(0xFFD26900),
      secondaryContainer: Color(0xFFFFD270),
      tertiary: Color(0xFF5C5C95),
      tertiaryContainer: Color(0xFFC8DBF8),
      appBarColor: Color(0xFFC8DCF8),
      swapOnMaterial3: true,
    ),
    // Convenience direct styling properties.
    appBarStyle: FlexAppBarStyle.primary,
    appBarElevation: 4.0,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    bottomAppBarElevation: 8.0,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      useM2StyleDividerInM3: true,
      adaptiveElevationShadowsBack: FlexAdaptive.all(),
      adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
      defaultRadius: 4.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primary,
      inputDecoratorSchemeColor: SchemeColor.onSurface,
      inputDecoratorIsFilled: true,
      inputDecoratorBackgroundAlpha: 13,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      listTileMinVerticalPadding: 4.0,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.secondary,
      chipSchemeColor: SchemeColor.primary,
      chipRadius: 20.0,
      popupMenuElevation: 8.0,
      alignedDropdown: true,
      tooltipRadius: 4,
      dialogElevation: 24.0,
      datePickerHeaderBackgroundSchemeColor: SchemeColor.primary,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      appBarScrolledUnderElevation: 4.0,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      tabBarIndicatorWeight: 2,
      tabBarIndicatorTopRadius: 0,
      tabBarDividerColor: Color(0x00000000),
      drawerElevation: 16.0,
      drawerWidth: 304.0,
      bottomSheetElevation: 10.0,
      bottomSheetModalElevation: 20.0,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: true,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedIcon: true,
      bottomNavigationBarElevation: 8.0,
      menuElevation: 8.0,
      menuBarRadius: 0.0,
      menuBarElevation: 1.0,
      navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
      navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
      navigationBarMutedUnselectedLabel: true,
      navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
      navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
      navigationBarMutedUnselectedIcon: true,
      navigationBarIndicatorSchemeColor: SchemeColor.secondary,
      navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
      navigationBarElevation: 0.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
      navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
      navigationRailMutedUnselectedLabel: true,
      navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
      navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
      navigationRailMutedUnselectedIcon: true,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.secondary,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Playground built-in scheme made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFFB1CFF5),
      primaryContainer: Color(0xFF3873BA),
      primaryLightRef: Color(0xFF00296B), // The color of light mode primary
      secondary: Color(0xFFFFD270),
      secondaryContainer: Color(0xFFD26900),
      secondaryLightRef: Color(0xFFD26900), // The color of light mode secondary
      tertiary: Color(0xFFC9CBFC),
      tertiaryContainer: Color(0xFF535393),
      tertiaryLightRef: Color(0xFF5C5C95), // The color of light mode tertiary
      appBarColor: Color(0xFF00102B),
      swapOnMaterial3: true,
    ),
    // Convenience direct styling properties.
    appBarStyle: FlexAppBarStyle.material,
    appBarElevation: 4.0,
    bottomAppBarElevation: 8.0,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      useM2StyleDividerInM3: true,
      adaptiveElevationShadowsBack: FlexAdaptive.all(),
      adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
      defaultRadius: 4.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primary,
      inputDecoratorSchemeColor: SchemeColor.onSurface,
      inputDecoratorIsFilled: true,
      inputDecoratorBackgroundAlpha: 20,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      listTileMinVerticalPadding: 4.0,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.secondary,
      chipSchemeColor: SchemeColor.primary,
      chipRadius: 20.0,
      popupMenuElevation: 8.0,
      alignedDropdown: true,
      tooltipRadius: 4,
      dialogElevation: 24.0,
      datePickerHeaderBackgroundSchemeColor: SchemeColor.primary,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      appBarScrolledUnderElevation: 4.0,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      tabBarIndicatorWeight: 2,
      tabBarIndicatorTopRadius: 0,
      tabBarDividerColor: Color(0x00000000),
      drawerElevation: 16.0,
      drawerWidth: 304.0,
      bottomSheetElevation: 10.0,
      bottomSheetModalElevation: 20.0,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: true,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedIcon: true,
      bottomNavigationBarElevation: 8.0,
      menuElevation: 8.0,
      menuBarRadius: 0.0,
      menuBarElevation: 1.0,
      navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
      navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
      navigationBarMutedUnselectedLabel: true,
      navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
      navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
      navigationBarMutedUnselectedIcon: true,
      navigationBarIndicatorSchemeColor: SchemeColor.secondary,
      navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
      navigationBarElevation: 0.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
      navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
      navigationRailMutedUnselectedLabel: true,
      navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
      navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
      navigationRailMutedUnselectedIcon: true,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.secondary,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
