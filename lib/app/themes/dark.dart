import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const blackGrey = Color.fromARGB(255, 27, 27, 27);

const darkGrey = Color.fromARGB(255, 70, 70, 70);

// Define the light theme
ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // Use the colorScheme property to define the primary, accent and background colors

    scaffoldBackgroundColor: blackGrey,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4169E1), // Royal blue hex code from [^2^][1]
      onPrimary: Colors.white, // Use white for text and icons on primary color
      secondary: Colors.grey, // Use white for accent color
      onSecondary: Color(
          0xFF4169E1), // Use royal blue for text and icons on accent color
      background: blackGrey,

      surface: darkGrey,
      onSurface: Colors.white,
      onBackground:
          Colors.white, // Use black for text and icons on background color
      // Fill in the rest of the color properties as needed
    ),
    textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
      titleLarge: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white),
      titleMedium: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
      titleSmall: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
      bodySmall: TextStyle(fontSize: 13, color: Colors.white),
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
    iconTheme: const IconThemeData(color: Colors.white),

    // Use the inputDecorationTheme property to define the appearance of text fields
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey[200]!)),
      iconColor: Colors.grey[200]!,
      filled: true,
      fillColor: darkGrey,
      labelStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    dialogTheme: const DialogTheme(backgroundColor: darkGrey),
    cardColor: darkGrey,
    cardTheme: const CardTheme(color: darkGrey),
    dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle:
            MenuStyle(backgroundColor: MaterialStatePropertyAll(darkGrey)),
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)))));
