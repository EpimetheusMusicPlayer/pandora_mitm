import 'package:flutter/material.dart';

/// Colors
const _primaryColor = 0xFF332B57;
const _secondaryColor = 0xFFC591F2;

/// The page transition builder to use on all platforms.
const _defaultPageTransitionsBuilder = CupertinoPageTransitionsBuilder();

ThemeData get themeData => ThemeData(
      // https://maketintsandshades.com/#332B57
      primaryColor: const Color(_primaryColor),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: const MaterialColor(
          _primaryColor,
          {
            50: Color(0xFF9995AB),
            100: Color(0xFF85809A),
            200: Color(0xFF706B89),
            300: Color(0xFF5C5579),
            400: Color(0xFF474068),
            500: Color(_primaryColor),
            600: Color(0xFF2E274E),
            700: Color(0xFF292246),
            800: Color(0xFF241E3D),
            900: Color(0xFF1F1A34),
          },
        ),
        accentColor: const Color(_secondaryColor),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _defaultPageTransitionsBuilder,
          TargetPlatform.iOS: _defaultPageTransitionsBuilder,
          TargetPlatform.macOS: _defaultPageTransitionsBuilder,
          TargetPlatform.linux: _defaultPageTransitionsBuilder,
          TargetPlatform.windows: _defaultPageTransitionsBuilder,
          TargetPlatform.fuchsia: _defaultPageTransitionsBuilder,
        },
      ),
      appBarTheme: const AppBarTheme(toolbarHeight: 48),
      indicatorColor: const Color(_secondaryColor),
    );

ThemeData get darkThemeData => themeData.copyWith();
