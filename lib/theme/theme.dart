// import 'package:flutter/material.dart';

// final ThemeData theme = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.light, // Keep it light for white background
//   scaffoldBackgroundColor: Colors.white, // App background
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Colors.green, // AppBar = Green
//     elevation: 2.0,
//     foregroundColor: Colors.white, // AppBar text/icon color
//   ),
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: Colors.green,
//     brightness: Brightness.light,
//     background: Colors.white,
//     primary: Colors.green, // Primary elements (buttons, etc.) = Green
//     onPrimary: Colors.white, // Text on buttons = White
//     secondary: Colors.greenAccent,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.green,
//       foregroundColor: Colors.white,
//       textStyle: const TextStyle(fontWeight: FontWeight.bold),
//     ),
//   ),
// );

import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: 'Montserrat',

  scaffoldBackgroundColor: const Color(0xFF121212), // Deeper black

  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF7A5FFF),
    brightness: Brightness.dark,
    primary: Color(0xFF7A5FFF), // Main purple
    onPrimary: Colors.white,
    secondary: Color(0xFF7A5FFF),
    background: Color(0xFF121212),
    surface: Color(0xFF1E1C24),
    onSurface: Colors.white70,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF7A5FFF)),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      backgroundColor: const Color(0xFF7A5FFF),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 8,
      shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
    ),
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF1E1C24),
    elevation: 10,
    margin: const EdgeInsets.all(16),
    shadowColor: Colors.black54,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  ),

  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.white70, height: 1.4),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF7A5FFF),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1C24),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(color: Colors.grey[500]),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF7A5FFF),
    contentTextStyle: const TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
);
