// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    theme.Assets.images.android.ball.keyName,
    theme.Assets.images.dash.ball.keyName,
    theme.Assets.images.dino.ball.keyName,
    theme.Assets.images.sparky.ball.keyName,
  ];

  final flameTester = FlameTester(() => TestGame(assets));

  group('Ball', () {
    test(
      'can be instantiated',
      () {
        expect(Ball(), isA<Ball>());
        expect(Ball.test(), isA<Ball>());
      },
    );

    testWithGame<TestGame>(
      'loads correctly',
      flameTester.createGame,
      (game) async {
        final ball = Ball();
        await game.ready();
        await game.ensureAdd(ball);

        expect(game.contains(ball), isTrue);
      },
    );

    testWithGame<TestGame>(
      'has only one SpriteComponent',
      flameTester.createGame,
      (game) async {
        final ball = Ball();
        await game.ready();
        await game.ensureAdd(ball);

        expect(
          ball.descendants().whereType<SpriteComponent>().length,
          equals(1),
        );
      },
    );

    testWithGame<TestGame>(
      'BallSpriteComponent changes sprite onNewState',
      flameTester.createGame,
      (game) async {
        final ball = Ball();
        await game.ready();
        await game.ensureAdd(ball);

        final ballSprite =
            ball.descendants().whereType<BallSpriteComponent>().single;
        final originalSprite = ballSprite.sprite;

        ballSprite.onNewState(
          const BallState(characterTheme: theme.DinoTheme()),
        );
        await game.ready();

        final newSprite = ballSprite.sprite;
        expect(newSprite != originalSprite, isTrue);
      },
    );

    group('adds', () {
      testWithGame<TestGame>('a BallScalingBehavior',
          flameTester.createGame,
          (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);
        expect(
          ball.descendants().whereType<BallScalingBehavior>().length,
          equals(1),
        );
      });

      testWithGame<TestGame>('a BallGravitatingBehavior',
          flameTester.createGame,
              (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);
        expect(
          ball.descendants().whereType<BallGravitatingBehavior>().length,
          equals(1),
        );
      });
    });

    group('body', () {
      testWithGame<TestGame>(
        'is dynamic',
        flameTester.createGame,
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          expect(ball.body.bodyType, equals(BodyType.dynamic));
        },
      );

      group('can be moved', () {
        testWithGame<TestGame>('by its weight',
            flameTester.createGame, (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          game.update(1);
          expect(ball.body.position, isNot(equals(ball.initialPosition)));
        });

        testWithGame<TestGame>('by applying velocity',
            flameTester.createGame,
                (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          ball.body.gravityScale = Vector2.zero();
          ball.body.linearVelocity.setValues(10, 10);
          game.update(1);
          expect(ball.body.position, isNot(equals(ball.initialPosition)));
        });
      });
    });

    group('fixture', () {
      testWithGame<TestGame>(
        'exists',
        flameTester.createGame,
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          expect(ball.body.fixtures[0], isA<Fixture>());
        },
      );

      testWithGame<TestGame>(
        'is dense',
        flameTester.createGame,
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );

      testWithGame<TestGame>(
        'shape is circular',
        flameTester.createGame,
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(2.065));
        },
      );

      testWithGame<TestGame>(
        'has Layer.all as default filter maskBits',
        flameTester.createGame,
        (game) async {
          final ball = Ball();
          await game.ready();
          await game.ensureAdd(ball);
          await game.ready();

          final fixture = ball.body.fixtures[0];
          expect(fixture.filterData.maskBits, equals(Layer.board.maskBits));
        },
      );
    });

    group('stop', () {
      group("can't be moved", () {
        testWithGame<TestGame>('by its weight',
            flameTester.createGame,
                (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);
          ball.stop();

          game.update(1);
          expect(ball.body.position, equals(ball.initialPosition));
        });
      });
    });

    group('resume', () {
      group('can move', () {
        testWithGame<TestGame>(
          'by its weight when previously stopped',
          flameTester.createGame,
          (game) async {
            final ball = Ball();
            await game.ensureAdd(ball);
            ball.stop();
            ball.resume();

            game.update(1);
            expect(ball.body.position, isNot(equals(ball.initialPosition)));
          },
        );

        testWithGame<TestGame>(
          'by applying velocity when previously stopped',
          flameTester.createGame,
              (game) async {
            final ball = Ball();
            await game.ensureAdd(ball);
            ball.stop();
            ball.resume();

            ball.body.gravityScale = Vector2.zero();
            ball.body.linearVelocity.setValues(10, 10);
            game.update(1);
            expect(ball.body.position, isNot(equals(ball.initialPosition)));
          },
        );
      });
    });
  });
}
