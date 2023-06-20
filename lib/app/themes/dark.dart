// Define the dark theme
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  // Use the colorScheme property to define the primary, accent and background colors
  colorScheme: const ColorScheme.dark(
    primary: Colors.white, // Use white for primary color
    onPrimary:
        Color(0xFF4169E1), // Use royal blue for text and icons on primary color
    secondary: Color(0xFF4169E1), // Use royal blue for accent color
    onSecondary: Colors.white, // Use white for text and icons on accent color
    background: Color(0xFFA8A8A8), // Use dark gray for background color
    onBackground:
        Colors.white, // Use white for text and icons on background color
    // Fill in the rest of the color properties as needed
  ),
  textTheme: GoogleFonts
      .poppinsTextTheme(), // Use google fonts poppins for the text theme
  // Use the buttonTheme property to define the appearance of buttons
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: const BorderSide(
          color: Colors.white), // Use white for button border color
    ),
    height: 50.0,
    minWidth: 150.0,
    buttonColor:
        Colors.transparent, // Use transparent for button background color
    textTheme: ButtonTextTheme
        .primary, // Use primary color (royal blue) for button text color
  ),
  // Use the inputDecorationTheme property to define the appearance of text fields
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
          color: Colors.white), // Use white for text field border color
    ),
    filled: true,
    fillColor: const Color(
        0xFF4169E1), // Use royal blue for text field background color
    labelStyle: const TextStyle(
      color: Colors.white, // Use white for text field label color
    ),
  ),
);
