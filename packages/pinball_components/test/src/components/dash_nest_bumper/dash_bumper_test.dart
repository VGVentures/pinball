// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/dash_bumper/behaviors/behaviors.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.dash.bumper.main.active.keyName,
      Assets.images.dash.bumper.main.inactive.keyName,
      Assets.images.dash.bumper.a.active.keyName,
      Assets.images.dash.bumper.a.inactive.keyName,
      Assets.images.dash.bumper.b.active.keyName,
      Assets.images.dash.bumper.b.inactive.keyName,
    ]);
  }

  Future<void> pump(DashBumper child) async {
    await ensureAdd(
      FlameBlocProvider<DashBumpersCubit, DashBumpersState>.value(
        value: DashBumpersCubit(),
        children: [child],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('DashBumper', () {
    testWithGame<_TestGame>('"main" can be added', flameTester.createGame,
        (game) async {
      final bumper = DashBumper.main();
      await game.pump(bumper);
      expect(game.descendants().contains(bumper), isTrue);
    });

    testWithGame<_TestGame>('"a" can be added', flameTester.createGame,
        (game) async {
      final bumper = DashBumper.a();
      await game.pump(bumper);
      expect(game.descendants().contains(bumper), isTrue);
    });

    testWithGame<_TestGame>('"b" can be added', flameTester.createGame,
        (game) async {
      final bumper = DashBumper.b();
      await game.pump(bumper);
      expect(game.descendants().contains(bumper), isTrue);
    });

    testWithGame<_TestGame>(
        'adds a DashBumperBallContactBehavior', flameTester.createGame,
        (game) async {
      final bumper = DashBumper.a();
      await game.pump(bumper);
      expect(
        bumper.children.whereType<DashBumperBallContactBehavior>().single,
        isNotNull,
      );
    });

    group("'main' adds", () {
      testWithGame<_TestGame>('new children', flameTester.createGame,
          (game) async {
        final component = Component();
        final bumper = DashBumper.main(
          children: [component],
        );
        await game.pump(bumper);
        expect(bumper.children, contains(component));
      });

      testWithGame<_TestGame>('a BumpingBehavior', flameTester.createGame,
          (game) async {
        final bumper = DashBumper.main();
        await game.pump(bumper);
        expect(
          bumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group("'a' adds", () {
      testWithGame<_TestGame>('new children', flameTester.createGame,
          (game) async {
        final component = Component();
        final bumper = DashBumper.a(
          children: [component],
        );
        await game.pump(bumper);
        expect(bumper.children, contains(component));
      });

      testWithGame<_TestGame>('a BumpingBehavior', flameTester.createGame,
          (game) async {
        final bumper = DashBumper.a();
        await game.pump(bumper);
        expect(
          bumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group("'b' adds", () {
      testWithGame<_TestGame>('new children', flameTester.createGame,
          (game) async {
        final component = Component();
        final bumper = DashBumper.b(
          children: [component],
        );
        await game.pump(bumper);
        expect(bumper.children, contains(component));
      });

      testWithGame<_TestGame>('a BumpingBehavior', flameTester.createGame,
          (game) async {
        final bumper = DashBumper.b();
        await game.pump(bumper);
        expect(
          bumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group('SpriteGroupComponent', () {
      const mainBumperActivatedState = DashBumpersState(
        bumperSpriteStates: {
          DashBumperId.main: DashBumperSpriteState.active,
          DashBumperId.a: DashBumperSpriteState.inactive,
          DashBumperId.b: DashBumperSpriteState.inactive,
        },
      );

      group('listenWhen', () {
        testWithGame<_TestGame>(
          'is true when the sprite state for the given ID has changed',
          flameTester.createGame,
          (game) async {
            final bumper = DashBumper.main();
            await game.pump(bumper);

            final listenWhen =
                bumper.firstChild<DashBumperSpriteGroupComponent>()!.listenWhen(
                      DashBumpersState.initial(),
                      mainBumperActivatedState,
                    );

            expect(listenWhen, isTrue);
          },
        );

        testWithGame<_TestGame>(
          'onNewState updates the current sprite',
          flameTester.createGame,
          (game) async {
            final bumper = DashBumper.main();
            await game.pump(bumper);

            final spriteGroupComponent =
                bumper.firstChild<DashBumperSpriteGroupComponent>()!;
            final originalSprite = spriteGroupComponent.current;

            spriteGroupComponent.onNewState(mainBumperActivatedState);
            await game.ready();

            final newSprite = spriteGroupComponent.current;
            expect(newSprite, isNot(equals(originalSprite)));
          },
        );
      });
    });
  });
}
