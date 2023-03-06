// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/kicker/behaviors/behaviors.dart';

import '../../helpers/helpers.dart';

class _MockKickerCubit extends Mock implements KickerCubit {}

void main() {
  group('Kicker', () {
    final assets = [
      Assets.images.kicker.left.lit.keyName,
      Assets.images.kicker.left.dimmed.keyName,
      Assets.images.kicker.right.lit.keyName,
      Assets.images.kicker.right.dimmed.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final leftKicker = Kicker(
          side: BoardSide.left,
        )
          ..initialPosition = Vector2(-20, 0)
          ..renderBody = false;
        final rightKicker = Kicker(
          side: BoardSide.right,
        )..initialPosition = Vector2(20, 0);

        await game.ensureAddAll([leftKicker, rightKicker]);
        game.camera.followVector2(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/kickers.png'),
        );
      },
    );

    testWithGame<TestGame>(
      'loads correctly',
      flameTester.createGame,
      (game) async {
        final kicker = Kicker.test(
          side: BoardSide.left,
          bloc: KickerCubit(),
        );
        await game.ensureAdd(kicker);

        expect(game.contains(kicker), isTrue);
      },
    );

    testWithGame<TestGame>('closes bloc when removed',
        flameTester.createGame, (game) async {
      final bloc = _MockKickerCubit();
      whenListen(
        bloc,
        const Stream<KickerState>.empty(),
        initialState: KickerState.lit,
      );
      when(bloc.close).thenAnswer((_) async {});
      final kicker = Kicker.test(
        side: BoardSide.left,
        bloc: bloc,
      );

      await game.ensureAdd(kicker);
      game.remove(kicker);
      await game.ready();

      verify(bloc.close).called(1);
    });

    group('adds', () {
      testWithGame<TestGame>('new children',
          flameTester.createGame, (game) async {
        final component = Component();
        final kicker = Kicker(
          side: BoardSide.left,
          children: [component],
        );
        await game.ensureAdd(kicker);
        expect(kicker.children, contains(component));
      });

      testWithGame<TestGame>('a BumpingBehavior',
          flameTester.createGame, (game) async {
        final kicker = Kicker(
          side: BoardSide.left,
        );
        await game.ensureAdd(kicker);
        expect(
          kicker.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });

      testWithGame<TestGame>('a KickerBallContactBehavior',
          flameTester.createGame, (game) async {
        final kicker = Kicker(
          side: BoardSide.left,
        );
        await game.ensureAdd(kicker);
        expect(
          kicker.children.whereType<KickerBallContactBehavior>().single,
          isNotNull,
        );
      });

      testWithGame<TestGame>('a KickerBlinkingBehavior',
          flameTester.createGame, (game) async {
        final kicker = Kicker(
          side: BoardSide.left,
        );
        await game.ensureAdd(kicker);
        expect(
          kicker.children.whereType<KickerBlinkingBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
