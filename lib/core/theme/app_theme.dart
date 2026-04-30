import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Color(0xFFF5F7FB),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );
}