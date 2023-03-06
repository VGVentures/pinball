// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('JointAnchor', () {
    testWithGame<Forge2DGame>(
      'loads correctly',
      flameTester.createGame,
      (game) async {
        final anchor = JointAnchor();
        await game.ready();
        await game.ensureAdd(anchor);

        expect(game.contains(anchor), isTrue);
      },
    );

    group('body', () {
      testWithGame<Forge2DGame>(
        'is static',
        flameTester.createGame,
        (game) async {
          await game.ready();
          final anchor = JointAnchor();
          await game.ensureAdd(anchor);

          expect(anchor.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('fixtures', () {
      testWithGame<Forge2DGame>(
        'has none',
        flameTester.createGame,
        (game) async {
          final anchor = JointAnchor();
          await game.ensureAdd(anchor);

          expect(anchor.body.fixtures, isEmpty);
        },
      );
    });
  });
}
