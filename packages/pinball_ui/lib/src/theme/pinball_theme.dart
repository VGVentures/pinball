import 'package:flutter/material.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// Pinball theme
class PinballTheme {
  /// Standard [ThemeData] for Pinball UI
  static ThemeData get standard {
    return ThemeData(
      textTheme: _textTheme,
    );
  }

  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: PinballTextStyle.headline1,
      displayMedium: PinballTextStyle.headline2,
      displaySmall: PinballTextStyle.headline3,
      headlineLarge: PinballTextStyle.headline4,
      headlineMedium: PinballTextStyle.headline5,
      titleMedium: PinballTextStyle.subtitle1,
    );
  }
}
