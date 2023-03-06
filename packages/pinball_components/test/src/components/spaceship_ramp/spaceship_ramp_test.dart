// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/spaceship_ramp/behavior/behavior.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.android.ramp.boardOpening.keyName,
      Assets.images.android.ramp.railingForeground.keyName,
      Assets.images.android.ramp.railingBackground.keyName,
      Assets.images.android.ramp.main.keyName,
      Assets.images.android.ramp.arrow.inactive.keyName,
      Assets.images.android.ramp.arrow.active1.keyName,
      Assets.images.android.ramp.arrow.active2.keyName,
      Assets.images.android.ramp.arrow.active3.keyName,
      Assets.images.android.ramp.arrow.active4.keyName,
      Assets.images.android.ramp.arrow.active5.keyName,
    ]);
  }

  Future<void> pump(
    SpaceshipRamp children, {
    required SpaceshipRampCubit bloc,
  }) async {
    await ensureAdd(
      FlameBlocProvider<SpaceshipRampCubit, SpaceshipRampState>.value(
        value: bloc,
        children: [
          ZCanvasComponent(children: [children]),
        ],
      ),
    );
  }
}

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

class _MockManifold extends Mock implements Manifold {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('SpaceshipRamp', () {
    testWithGame<_TestGame>(
      'loads correctly',
      flameTester.createGame,
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: SpaceshipRampState.initial(),
        );
        final ramp = SpaceshipRamp.test();
        await game.pump(ramp, bloc: bloc);
        expect(game.descendants(), contains(ramp));
      },
    );

    group('adds', () {
      testWithGame<_TestGame>('a FlameBlocProvider',
          flameTester.createGame, (game) async {
        final ramp = SpaceshipRamp();
        await game.ensureAdd(ramp);
        expect(
          ramp.children
              .whereType<
                  FlameBlocProvider<SpaceshipRampCubit, SpaceshipRampState>>()
              .single,
          isNotNull,
        );
      });

      testWithGame<_TestGame>(
        'a SpaceshipRampBoardOpening',
        flameTester.createGame,
        (game) async {
          final ramp = SpaceshipRamp();
          await game.ensureAdd(ramp);

          expect(
            game.descendants().whereType<SpaceshipRampBoardOpening>().length,
            equals(1),
          );
        },
      );

      testWithGame<_TestGame>(
        'a SpaceshipRampArrowSpriteComponent',
        flameTester.createGame,
        (game) async {
          final ramp = SpaceshipRamp();
          await game.ensureAdd(ramp);

          expect(
            game
                .descendants()
                .whereType<SpaceshipRampArrowSpriteComponent>()
                .length,
            equals(1),
          );
        },
      );

      testWithGame<_TestGame>('new children',
          flameTester.createGame, (game) async {
        final component = Component();
        final ramp = SpaceshipRamp(children: [component]);
        await game.ensureAdd(ramp);

        expect(ramp.descendants(), contains(component));
      });
    });
  });

  group('SpaceshipRampBase', () {
    test('can be instantiated', () {
      expect(SpaceshipRampBase(), isA<SpaceshipRampBase>());
    });

    testWithGame<_TestGame>('can be loaded',
        flameTester.createGame, (game) async {
      final component = SpaceshipRampBase();
      await game.ensureAdd(component);
      expect(game.children, contains(component));
    });

    testWithGame<_TestGame>(
      'postSolves disables contact when ball is not on Layer.board',
      flameTester.createGame,
      (game) async {
        final ball = _MockBall();
        final contact = _MockContact();
        when(() => ball.layer).thenReturn(Layer.spaceshipEntranceRamp);
        final component = SpaceshipRampBase();
        await game.ensureAdd(component);

        component.preSolve(ball, contact, _MockManifold());

        verify(() => contact.setEnabled(false)).called(1);
      },
    );

    testWithGame<_TestGame>(
      'postSolves enables contact when ball is on Layer.board',
      flameTester.createGame,
      (game) async {
        final ball = _MockBall();
        final contact = _MockContact();
        when(() => ball.layer).thenReturn(Layer.board);
        final component = SpaceshipRampBase();
        await game.ensureAdd(component);

        component.preSolve(ball, contact, _MockManifold());

        verify(() => contact.setEnabled(true)).called(1);
      },
    );
  });

  group('SpaceshipRampBoardOpening', () {
    test('can be instantiated', () {
      expect(SpaceshipRampBoardOpening(), isA<SpaceshipRampBoardOpening>());
    });

    testWithGame<_TestGame>('can be loaded',
        flameTester.createGame, (game) async {
      final component = SpaceshipRampBoardOpening();
      final parent = SpaceshipRamp.test();
      await game.pump(parent, bloc: _MockSpaceshipRampCubit());

      await parent.ensureAdd(component);
      expect(parent.children, contains(component));
    });

    testWithGame<_TestGame>('adds a RampBallAscendingContactBehavior',
        flameTester.createGame, (game) async {
      final component = SpaceshipRampBoardOpening();
      final parent = SpaceshipRamp.test();
      await game.pump(parent, bloc: _MockSpaceshipRampCubit());

      await parent.ensureAdd(component);
      expect(
        component.children.whereType<RampBallAscendingContactBehavior>().length,
        equals(1),
      );
    });
  });

  group('SpaceshipRampArrowSpriteComponent', () {
    testWithGame<_TestGame>(
      'changes current state '
      'when SpaceshipRampState changes lightState',
      flameTester.createGame,
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final state = SpaceshipRampState.initial();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: state,
        );
        final arrow = SpaceshipRampArrowSpriteComponent();
        final ramp = SpaceshipRamp.test(children: [arrow]);
        await game.pump(
          ramp,
          bloc: bloc,
        );

        expect(arrow.current, ArrowLightState.inactive);

        streamController
            .add(state.copyWith(lightState: ArrowLightState.active1));

        await game.ready();

        expect(arrow.current, ArrowLightState.active1);
      },
    );
  });
}
