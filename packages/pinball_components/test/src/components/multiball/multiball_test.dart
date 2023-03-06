// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/multiball/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class _MockMultiballCubit extends Mock implements MultiballCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiball.lit.keyName,
    Assets.images.multiball.dimmed.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('Multiball', () {
    group('loads correctly', () {
      testWithGame<TestGame>('"a"',
          flameTester.createGame, (game) async {
        final multiball = Multiball.a();
        await game.ensureAdd(multiball);

        expect(game.contains(multiball), isTrue);
      });

      testWithGame<TestGame>('"b"',
          flameTester.createGame, (game) async {
        final multiball = Multiball.b();
        await game.ensureAdd(multiball);
        expect(game.contains(multiball), isTrue);
      });

      testWithGame<TestGame>('"c"',
          flameTester.createGame, (game) async {
        final multiball = Multiball.c();
        await game.ensureAdd(multiball);

        expect(game.contains(multiball), isTrue);
      });

      testWithGame<TestGame>('"d"',
          flameTester.createGame, (game) async {
        final multiball = Multiball.d();
        await game.ensureAdd(multiball);
        expect(game.contains(multiball), isTrue);
      });
    });

    testWithGame<TestGame>(
      'closes bloc when removed',
      flameTester.createGame,
      (game) async {
        final bloc = _MockMultiballCubit();
        whenListen(
          bloc,
          const Stream<MultiballLightState>.empty(),
          initialState: MultiballLightState.dimmed,
        );
        when(bloc.close).thenAnswer((_) async {});
        final multiball = Multiball.test(bloc: bloc);

        await game.ensureAdd(multiball);
        game.remove(multiball);
        await game.ready();

        verify(bloc.close).called(1);
      },
    );

    group('adds', () {
      testWithGame<TestGame>('new children',
          flameTester.createGame, (game) async {
        final component = Component();
        final multiball = Multiball.a(
          children: [component],
        );
        await game.ensureAdd(multiball);
        expect(multiball.children, contains(component));
      });

      testWithGame<TestGame>('a MultiballBlinkingBehavior',
          flameTester.createGame, (game) async {
        final multiball = Multiball.a();
        await game.ensureAdd(multiball);
        expect(
          multiball.children.whereType<MultiballBlinkingBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
