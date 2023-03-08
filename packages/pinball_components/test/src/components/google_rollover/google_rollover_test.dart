// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/google_rollover/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.googleRollover.left.decal.keyName,
    Assets.images.googleRollover.left.pin.keyName,
    Assets.images.googleRollover.right.decal.keyName,
    Assets.images.googleRollover.right.pin.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('GoogleRollover', () {
    test('can be instantiated', () {
      expect(
        GoogleRollover(side: BoardSide.left),
        isA<GoogleRollover>(),
      );
    });

    testWithGame<TestGame>('left loads correctly', flameTester.createGame,
        (game) async {
      final googleRollover = GoogleRollover(side: BoardSide.left);
      await game.ensureAdd(googleRollover);
      expect(game.contains(googleRollover), isTrue);
    });

    testWithGame<TestGame>('right loads correctly', flameTester.createGame,
        (game) async {
      final googleRollover = GoogleRollover(side: BoardSide.right);
      await game.ensureAdd(googleRollover);
      expect(game.contains(googleRollover), isTrue);
    });

    group('adds', () {
      testWithGame<TestGame>('new children', flameTester.createGame,
          (game) async {
        final component = Component();
        final googleRollover = GoogleRollover(
          side: BoardSide.left,
          children: [component],
        );
        await game.ensureAdd(googleRollover);
        expect(googleRollover.children, contains(component));
      });

      testWithGame<TestGame>(
          'a GoogleRolloverBallContactBehavior', flameTester.createGame,
          (game) async {
        final googleRollover = GoogleRollover(side: BoardSide.left);
        await game.ensureAdd(googleRollover);
        expect(
          googleRollover.children
              .whereType<GoogleRolloverBallContactBehavior>()
              .single,
          isNotNull,
        );
      });
    });

    testWithGame<TestGame>(
      'pin stops animating after animation completes',
      flameTester.createGame,
      (game) async {
        final googleRollover = GoogleRollover(side: BoardSide.left);
        await game.ensureAdd(googleRollover);

        final pinSpriteAnimationComponent =
            googleRollover.firstChild<SpriteAnimationComponent>()!;

        pinSpriteAnimationComponent.playing = true;
        game.update(
          pinSpriteAnimationComponent.animation!.totalDuration() + 0.1,
        );

        expect(pinSpriteAnimationComponent.playing, isFalse);
      },
    );
  });
}
