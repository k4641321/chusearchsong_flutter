import 'package:flutter/material.dart';

final ColorScheme lightTheme = ColorScheme.light(
  brightness: Brightness.light,
  primary: const Color.fromARGB(255, 255, 239, 146),
  onSecondary: const Color.fromARGB(255, 223, 223, 223),
);

final ColorScheme darkTheme = ColorScheme.dark(
  brightness: Brightness.dark,
  primary: const Color.fromARGB(255, 193, 182, 123),
  onSecondary: const Color.fromARGB(255, 223, 223, 223),
);
