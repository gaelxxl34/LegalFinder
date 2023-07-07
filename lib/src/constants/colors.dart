import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFF000000),
  100: Color(0xFF000000),
  200: Color(0xFF050E34),
  300: Color(0xFF000000),
  400: Color(0xFF000000),
  500: Color(0xFF000000), // Set primary color to black
  600: Color(0xFFF80A0A),
  700: Color(0xFF020407),
  800: Color(0xFF000309),
  900: Color(0xFF100202),
});
const int _primaryPrimaryValue = 0xFF070000;

const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFF000000),
  200: Color(_primaryAccentValue),
  400: Color(0xFF000000),
  700: Color(0xFF000000),
});
const int _primaryAccentValue = 0xFF000000;