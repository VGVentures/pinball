// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    PlungerKeyControllingBehavior child, {
    PlungerCubit? plungerBloc,
  }) async {
    final plunger = Plunger.test();
    await ensureAdd(plunger);
    return plunger.ensureAdd(
      FlameBlocProvider<PlungerCubit, PlungerState>.value(
        value: plungerBloc ?? _MockPlungerCubit(),
        children: [child],
      ),
    );
  }
}

class _MockRawKeyDownEvent extends Mock implements RawKeyDownEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _MockRawKeyUpEvent extends Mock implements RawKeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _MockPlungerCubit extends Mock implements PlungerCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('PlungerKeyControllingBehavior', () {
    test('can be instantiated', () {
      expect(
        PlungerKeyControllingBehavior(),
        isA<PlungerKeyControllingBehavior>(),
      );
    });

    testWithGame<_TestGame>('can be loaded', flameTester.createGame,
        (game) async {
      final behavior = PlungerKeyControllingBehavior();
      await game.pump(behavior);
      expect(game.descendants(), contains(behavior));
    });

    group('onKeyEvent', () {
      late PlungerCubit plungerBloc;

      setUp(() {
        plungerBloc = _MockPlungerCubit();
      });

      group('pulls when', () {
        testWithGame<_TestGame>(
          'down arrow is pressed',
          flameTester.createGame,
          (game) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );

            final event = _MockRawKeyDownEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.arrowDown,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.pulled()).called(1);
          },
        );

        testWithGame<_TestGame>(
          '"s" is pressed',
          flameTester.createGame,
          (game) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );

            final event = _MockRawKeyDownEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.keyS,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.pulled()).called(1);
          },
        );

        testWithGame<_TestGame>(
          'space is pressed',
          flameTester.createGame,
          (game) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );

            final event = _MockRawKeyDownEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.space,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.pulled()).called(1);
          },
        );
      });

      group('releases when', () {
        testWithGame<_TestGame>(
          'down arrow is released',
          flameTester.createGame,
          (game) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );

            final event = _MockRawKeyUpEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.arrowDown,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.released()).called(1);
          },
        );

        testWithGame<_TestGame>(
          '"s" is released',
          flameTester.createGame,
          (game) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );

            final event = _MockRawKeyUpEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.keyS,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.released()).called(1);
          },
        );

        testWithGame<_TestGame>(
          'space is released',
          flameTester.createGame,
          (game) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );

            final event = _MockRawKeyUpEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.space,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.released()).called(1);
          },
        );
      });
    });
  });
}
