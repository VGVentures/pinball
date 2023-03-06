// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('Drain', () {
    testWithGame<Forge2DGame>(
      'loads correctly',
      flameTester.createGame,
      (game) async {
        final drain = Drain();
        await game.ensureAdd(drain);
        expect(game.contains(drain), isTrue);
      },
    );

    testWithGame<Forge2DGame>(
      'body is static',
      flameTester.createGame,
      (game) async {
        final drain = Drain();
        await game.ensureAdd(drain);
        expect(drain.body.bodyType, equals(BodyType.static));
      },
    );

    testWithGame<Forge2DGame>(
      'is sensor',
      flameTester.createGame,
      (game) async {
        final drain = Drain();
        await game.ensureAdd(drain);
        expect(drain.body.fixtures.first.isSensor, isTrue);
      },
    );
  });
}
