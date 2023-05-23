import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFE0E4EB),
  100: Color(0xFFB3BDCD),
  200: Color(0xFF8091AC),
  300: Color(0xFF4D648A),
  400: Color(0xFF264371),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF000000),
  700: Color(0xFF020407),
  800: Color(0xFF000309),
  900: Color(0xFF010207),
});
const int _primaryPrimaryValue = 0xFF002258;

const MaterialColor primaryAccent =
MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFF667AFF),
  200: Color(_primaryAccentValue),
  400: Color(0xFF0022FF),
  700: Color(0xFF001FE6),
});
const int _primaryAccentValue = 0xFF000309;