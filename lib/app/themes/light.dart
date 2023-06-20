import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define the light theme
ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // Use the colorScheme property to define the primary, accent and background colors

    scaffoldBackgroundColor: const Color.fromARGB(255, 241, 241, 241),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4169E1), // Royal blue hex code from [^2^][1]
      onPrimary: Colors.white, // Use white for text and icons on primary color
      secondary: Colors.white, // Use white for accent color
      onSecondary: Color(
          0xFF4169E1), // Use royal blue for text and icons on accent color
      background: Color(0xFFD3D3D3), // Use light gray for background color
      onBackground:
          Colors.black, // Use black for text and icons on background color
      // Fill in the rest of the color properties as needed
    ),
    textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
      titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
      titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
      bodySmall: TextStyle(fontSize: 13),
    )),

    // Use google fonts poppins for the text theme
    // Use the buttonTheme property to define the appearance of buttons
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 70.0,
      minWidth: 200.0,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      buttonColor:
          const Color(0xFF4169E1), // Use royal blue for button background color
      textTheme: ButtonTextTheme
          .primary, // Use primary color (white) for button text color
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            minimumSize: const Size(double.maxFinite, 70),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),

    // Use the inputDecorationTheme property to define the appearance of text fields
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      filled: true,
      fillColor: Colors.white, // Use white for text field background color
      labelStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black, // Use royal blue for text field label color
      ),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(),
        inputDecorationTheme:
            InputDecorationTheme(border: OutlineInputBorder())));
