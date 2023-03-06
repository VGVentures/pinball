// ignore_for_file: cascade_invocations

import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _FakeCubit extends Fake implements Cubit<Object> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(FlameGame.new);

  group(
    'FlameProvider',
    () {
      test('can be instantiated', () {
        expect(
          FlameProvider<bool>.value(true),
          isA<FlameProvider<bool>>(),
        );
      });

      testWithGame<FlameGame>('can be loaded',
          flameTester.createGame, (game) async {
        final component = FlameProvider<bool>.value(true);
        await game.ensureAdd(component);
        expect(game.children, contains(component));
      });

      testWithGame<FlameGame>('adds children',
          flameTester.createGame, (game) async {
        final component = Component();
        final provider = FlameProvider<bool>.value(
          true,
          children: [component],
        );
        await game.ensureAdd(provider);
        expect(provider.children, contains(component));
      });
    },
  );

  group('MultiFlameProvider', () {
    test('can be instantiated', () {
      expect(
        MultiFlameProvider(
          providers: [
            FlameProvider<bool>.value(true),
          ],
        ),
        isA<MultiFlameProvider>(),
      );
    });

    testWithGame<FlameGame>('adds multiple providers',
        flameTester.createGame, (game) async {
      final provider1 = FlameProvider<bool>.value(true);
      final provider2 = FlameProvider<bool>.value(true);
      final providers = MultiFlameProvider(
        providers: [provider1, provider2],
      );
      await game.ensureAdd(providers);
      expect(providers.children, contains(provider1));
      expect(provider1.children, contains(provider2));
    });

    testWithGame<FlameGame>('adds children under provider',
        flameTester.createGame, (game) async {
      final component = Component();
      final provider = FlameProvider<bool>.value(true);
      final providers = MultiFlameProvider(
        providers: [provider],
        children: [component],
      );
      await game.ensureAdd(providers);
      expect(provider.children, contains(component));
    });
  });

  group(
    'ReadFlameProvider',
    () {
      testWithGame<FlameGame>('loads provider',
          flameTester.createGame, (game) async {
        final component = Component();
        final provider = FlameProvider<bool>.value(
          true,
          children: [component],
        );
        await game.ensureAdd(provider);
        expect(component.readProvider<bool>(), isTrue);
      });

      testWithGame<FlameGame>(
        'throws assertionError when no provider is found',
        flameTester.createGame,
        (game) async {
          final component = Component();
          await game.ensureAdd(component);

          expect(
            () => component.readProvider<bool>(),
            throwsAssertionError,
          );
        },
      );
    },
  );

  group(
    'ReadFlameBlocProvider',
    () {
      testWithGame<FlameGame>('loads provider',
          flameTester.createGame, (game) async {
        final component = Component();
        final bloc = _FakeCubit();
        final provider = FlameBlocProvider<_FakeCubit, Object>.value(
          value: bloc,
          children: [component],
        );
        await game.ensureAdd(provider);
        expect(component.readBloc<_FakeCubit, Object>(), equals(bloc));
      });

      testWithGame<FlameGame>(
        'throws assertionError when no provider is found',
        flameTester.createGame,
        (game) async {
          final component = Component();
          await game.ensureAdd(component);

          expect(
            () => component.readBloc<_FakeCubit, Object>(),
            throwsAssertionError,
          );
        },
      );
    },
  );
}
