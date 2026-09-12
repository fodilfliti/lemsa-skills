import 'package:flutter/material.dart';
import 'package:flutter_scale_theme_kit/flutter_scale_theme_kit.dart';

/// Semantic look tokens — single source for `context.st` and Material themes.
final appST = STTheme(
  colors: STColors(
    primary: const STColor(light: Color(0xFF6750A4), dark: Color(0xFFD0BCFF)),
    surface: const STColor(light: Color(0xFFFFFFFF), dark: Color(0xFF1E1E1E)),
    background: const STColor(
      light: Color(0xFFF7F7F7),
      dark: Color(0xFF121212),
    ),
    text: const STColor(light: Color(0xFF1C1B1F), dark: Color(0xFFE6E1E5)),
  ),
  radius: const STRadius(sm: 8, md: 12, lg: 16),
  typography: const STTypography(
    label: STTextToken(fontSize: 14, fontWeight: FontWeight.w600),
    sublabel: STTextToken(fontSize: 12, colorName: 'textSecondary'),
  ),
  components: const STComponents(
    card: STComponent(elevation: 0),
    button: STComponent(elevation: 0),
  ),
);
