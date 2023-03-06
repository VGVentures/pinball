// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/sparky_scorch/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.sparky.computer.top.keyName,
      Assets.images.sparky.computer.base.keyName,
      Assets.images.sparky.computer.glow.keyName,
      Assets.images.sparky.animatronic.keyName,
      Assets.images.sparky.bumper.a.lit.keyName,
      Assets.images.sparky.bumper.a.dimmed.keyName,
      Assets.images.sparky.bumper.b.lit.keyName,
      Assets.images.sparky.bumper.b.dimmed.keyName,
      Assets.images.sparky.bumper.c.lit.keyName,
      Assets.images.sparky.bumper.c.dimmed.keyName,
    ]);
  }

  Future<void> pump(SparkyScorch child) async {
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

  final flameTester = FlameTester(_TestGame.new);

  group('SparkyScorch', () {
    testWithGame<_TestGame>('loads correctly',
        flameTester.createGame, (game) async {
      final component = SparkyScorch();
      await game.pump(component);
      expect(
        game.descendants().whereType<SparkyScorch>().length,
        equals(1),
      );
    });

    group('loads', () {
      testWithGame<_TestGame>(
        'a SparkyComputer',
        flameTester.createGame,
        (game) async {
          await game.pump(SparkyScorch());
          expect(
            game.descendants().whereType<SparkyComputer>().length,
            equals(1),
          );
        },
      );

      testWithGame<_TestGame>(
        'a SparkyAnimatronic',
        flameTester.createGame,
        (game) async {
          await game.pump(SparkyScorch());
          expect(
            game.descendants().whereType<SparkyAnimatronic>().length,
            equals(1),
          );
        },
      );

      testWithGame<_TestGame>(
        'three SparkyBumper',
        flameTester.createGame,
        (game) async {
          await game.pump(SparkyScorch());
          expect(
            game.descendants().whereType<SparkyBumper>().length,
            equals(3),
          );
        },
      );

      testWithGame<_TestGame>(
        'three SparkyBumpers with BumperNoiseBehavior',
        flameTester.createGame,
        (game) async {
          await game.pump(SparkyScorch());
          final bumpers = game.descendants().whereType<SparkyBumper>();
          for (final bumper in bumpers) {
            expect(
              bumper.firstChild<BumperNoiseBehavior>(),
              isNotNull,
            );
          }
        },
      );
    });

    group('adds', () {
      testWithGame<_TestGame>(
        'ScoringContactBehavior to SparkyComputer',
        flameTester.createGame,
        (game) async {
          await game.pump(SparkyScorch());

          final sparkyComputer =
              game.descendants().whereType<SparkyComputer>().single;
          expect(
            sparkyComputer.firstChild<ScoringContactBehavior>(),
            isNotNull,
          );
        },
      );

      testWithGame<_TestGame>('a SparkyComputerBonusBehavior',
          flameTester.createGame, (game) async {
        final sparkyScorch = SparkyScorch();
        await game.pump(sparkyScorch);
        expect(
          sparkyScorch.children.whereType<SparkyComputerBonusBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
