// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/android_acres/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.android.spaceship.saucer.keyName,
      Assets.images.android.spaceship.animatronic.keyName,
      Assets.images.android.spaceship.lightBeam.keyName,
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
      Assets.images.android.rail.main.keyName,
      Assets.images.android.rail.exit.keyName,
      Assets.images.android.bumper.a.lit.keyName,
      Assets.images.android.bumper.a.dimmed.keyName,
      Assets.images.android.bumper.b.lit.keyName,
      Assets.images.android.bumper.b.dimmed.keyName,
      Assets.images.android.bumper.cow.lit.keyName,
      Assets.images.android.bumper.cow.dimmed.keyName,
    ]);
  }

  Future<void> pump(AndroidAcres child) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [child],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AndroidAcres', () {
    final flameTester = FlameTester(_TestGame.new);

    testWithGame<_TestGame>('loads correctly',
        flameTester.createGame, (game) async {
      final component = AndroidAcres();
      await game.pump(component);
      expect(game.descendants(), contains(component));
    });

    group('loads', () {
      testWithGame<_TestGame>(
        'an AndroidSpaceship',
        flameTester.createGame,
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<AndroidSpaceship>().length,
            equals(1),
          );
        },
      );

      testWithGame<_TestGame>(
        'an AndroidAnimatronic',
        flameTester.createGame,
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<AndroidAnimatronic>().length,
            equals(1),
          );
        },
      );

      testWithGame<_TestGame>(
        'a SpaceshipRamp',
        flameTester.createGame,
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<SpaceshipRamp>().length,
            equals(1),
          );
        },
      );

      testWithGame<_TestGame>(
        'a SpaceshipRail',
        flameTester.createGame,
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<SpaceshipRail>().length,
            equals(1),
          );
        },
      );

      testWithGame<_TestGame>(
        'three AndroidBumper',
        flameTester.createGame,
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<AndroidBumper>().length,
            equals(3),
          );
        },
      );

      testWithGame<_TestGame>(
        'three AndroidBumpers with BumperNoiseBehavior',
        flameTester.createGame,
        (game) async {
          await game.pump(AndroidAcres());
          final bumpers = game.descendants().whereType<AndroidBumper>();
          for (final bumper in bumpers) {
            expect(
              bumper.firstChild<BumperNoiseBehavior>(),
              isA<BumperNoiseBehavior>(),
            );
          }
        },
      );

      testWithGame<_TestGame>(
        'one AndroidBumper with CowBumperNoiseBehavior',
        flameTester.createGame,
        (game) async {
          await game.pump(AndroidAcres());
          final bumpers = game.descendants().whereType<AndroidBumper>();

          expect(
            bumpers.singleWhere(
              (bumper) => bumper.firstChild<CowBumperNoiseBehavior>() != null,
            ),
            isA<AndroidBumper>(),
          );
        },
      );
    });

    testWithGame<_TestGame>('adds a FlameBlocProvider',
        flameTester.createGame, (game) async {
      final androidAcres = AndroidAcres();
      await game.pump(androidAcres);
      expect(
        androidAcres.children
            .whereType<
                FlameBlocProvider<AndroidSpaceshipCubit,
                    AndroidSpaceshipState>>()
            .single,
        isNotNull,
      );
    });

    testWithGame<_TestGame>('adds an AndroidSpaceshipBonusBehavior',
        flameTester.createGame, (game) async {
      final androidAcres = AndroidAcres();
      await game.pump(androidAcres);
      final provider = androidAcres.children
          .whereType<
              FlameBlocProvider<AndroidSpaceshipCubit, AndroidSpaceshipState>>()
          .single;
      expect(
        provider.children.whereType<AndroidSpaceshipBonusBehavior>().single,
        isNotNull,
      );
    });
  });
}
