import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PinballTheme', () {
    group('standard', () {
      test('headline1 matches PinballTextStyle#headline1', () {
        expect(
          PinballTheme.standard.textTheme.displayLarge!.fontSize,
          PinballTextStyle.headline1.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.displayLarge!.color,
          PinballTextStyle.headline1.color,
        );
        expect(
          PinballTheme.standard.textTheme.displayLarge!.fontFamily,
          PinballTextStyle.headline1.fontFamily,
        );
      });

      test('headline2 matches PinballTextStyle#headline2', () {
        expect(
          PinballTheme.standard.textTheme.displayMedium!.fontSize,
          PinballTextStyle.headline2.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.displayMedium!.fontFamily,
          PinballTextStyle.headline2.fontFamily,
        );
        expect(
          PinballTheme.standard.textTheme.displayMedium!.fontWeight,
          PinballTextStyle.headline2.fontWeight,
        );
      });

      test('headline3 matches PinballTextStyle#headline3', () {
        expect(
          PinballTheme.standard.textTheme.displaySmall!.fontSize,
          PinballTextStyle.headline3.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.displaySmall!.color,
          PinballTextStyle.headline3.color,
        );
        expect(
          PinballTheme.standard.textTheme.displaySmall!.fontFamily,
          PinballTextStyle.headline3.fontFamily,
        );
      });

      test('headline4 matches PinballTextStyle#headline5', () {
        expect(
          PinballTheme.standard.textTheme.headlineMedium!.fontSize,
          PinballTextStyle.headline5.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.headlineMedium!.color,
          PinballTextStyle.headline5.color,
        );
        expect(
          PinballTheme.standard.textTheme.headlineMedium!.fontFamily,
          PinballTextStyle.headline5.fontFamily,
        );
      });

      test('subtitle1 matches PinballTextStyle#subtitle1', () {
        expect(
          PinballTheme.standard.textTheme.titleMedium!.fontSize,
          PinballTextStyle.subtitle1.fontSize,
        );
        expect(
          PinballTheme.standard.textTheme.titleMedium!.color,
          PinballTextStyle.subtitle1.color,
        );
        expect(
          PinballTheme.standard.textTheme.titleMedium!.fontFamily,
          PinballTextStyle.subtitle1.fontFamily,
        );
      });
    });
  });
}
