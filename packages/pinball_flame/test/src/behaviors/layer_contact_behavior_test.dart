// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestBodyComponent extends BodyComponent {
  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1;
    return world.createBody(BodyDef())..createFixtureFromShape(shape);
  }
}

class _TestLayeredBodyComponent extends _TestBodyComponent with Layered {
  _TestLayeredBodyComponent({required Layer layer}) {
    layer = layer;
  }
}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('LayerContactBehavior', () {
    test('can be instantiated', () {
      expect(
        LayerContactBehavior(layer: Layer.all),
        isA<LayerContactBehavior>(),
      );
    });

    testWithGame<Forge2DGame>('can be loaded',
        flameTester.createGame, (game) async {
      final behavior = LayerContactBehavior(layer: Layer.all);
      final parent = _TestBodyComponent();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.children, contains(behavior));
    });

    testWithGame<Forge2DGame>('beginContact changes layer',
        flameTester.createGame, (game) async {
      const oldLayer = Layer.all;
      const newLayer = Layer.board;
      final behavior = LayerContactBehavior(layer: newLayer);
      final parent = _TestBodyComponent();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);

      final component = _TestLayeredBodyComponent(layer: oldLayer);

      behavior.beginContact(component, _MockContact());

      expect(component.layer, newLayer);
    });

    testWithGame<Forge2DGame>('endContact changes layer',
        flameTester.createGame, (game) async {
      const oldLayer = Layer.all;
      const newLayer = Layer.board;
      final behavior = LayerContactBehavior(
        layer: newLayer,
        onBegin: false,
      );
      final parent = _TestBodyComponent();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);

      final component = _TestLayeredBodyComponent(layer: oldLayer);

      behavior.endContact(component, _MockContact());

      expect(component.layer, newLayer);
    });
  });
}
