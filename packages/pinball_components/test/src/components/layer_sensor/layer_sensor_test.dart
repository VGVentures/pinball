// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/layer_sensor/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../helpers/helpers.dart';

class TestLayerSensor extends LayerSensor {
  TestLayerSensor({
    required LayerEntranceOrientation orientation,
    required int insideZIndex,
    required Layer insideLayer,
  }) : super(
          insideLayer: insideLayer,
          insideZIndex: insideZIndex,
          orientation: orientation,
        );

  @override
  Shape get shape => PolygonShape()..setAsBoxXY(1, 1);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);
  const insidePriority = 1;

  group('LayerSensor', () {
    testWithGame<TestGame>(
      'loads correctly',
      flameTester.createGame,
      (game) async {
        final layerSensor = TestLayerSensor(
          orientation: LayerEntranceOrientation.down,
          insideZIndex: insidePriority,
          insideLayer: Layer.spaceshipEntranceRamp,
        );
        await game.ensureAdd(layerSensor);

        expect(game.contains(layerSensor), isTrue);
      },
    );

    group('body', () {
      testWithGame<TestGame>(
        'is static',
        flameTester.createGame,
        (game) async {
          final layerSensor = TestLayerSensor(
            orientation: LayerEntranceOrientation.down,
            insideZIndex: insidePriority,
            insideLayer: Layer.spaceshipEntranceRamp,
          );
          await game.ensureAdd(layerSensor);

          expect(layerSensor.body.bodyType, equals(BodyType.static));
        },
      );

      group('first fixture', () {
        const pathwayLayer = Layer.spaceshipEntranceRamp;
        const openingLayer = Layer.opening;

        testWithGame<TestGame>(
          'exists',
          flameTester.createGame,
          (game) async {
            final layerSensor = TestLayerSensor(
              orientation: LayerEntranceOrientation.down,
              insideZIndex: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);

            expect(layerSensor.body.fixtures[0], isA<Fixture>());
          },
        );

        testWithGame<TestGame>(
          'shape is a polygon',
          flameTester.createGame,
          (game) async {
            final layerSensor = TestLayerSensor(
              orientation: LayerEntranceOrientation.down,
              insideZIndex: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);

            final fixture = layerSensor.body.fixtures[0];
            expect(fixture.shape.shapeType, equals(ShapeType.polygon));
          },
        );

        testWithGame<TestGame>(
          'is sensor',
          flameTester.createGame,
          (game) async {
            final layerSensor = TestLayerSensor(
              orientation: LayerEntranceOrientation.down,
              insideZIndex: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);

            final fixture = layerSensor.body.fixtures[0];
            expect(fixture.isSensor, isTrue);
          },
        );
      });
    });

    testWithGame<TestGame>(
      'adds a LayerFilteringBehavior',
      flameTester.createGame,
      (game) async {
        final layerSensor = TestLayerSensor(
          orientation: LayerEntranceOrientation.down,
          insideZIndex: insidePriority,
          insideLayer: Layer.spaceshipEntranceRamp,
        );
        await game.ensureAdd(layerSensor);

        expect(
          layerSensor.children.whereType<LayerFilteringBehavior>().length,
          equals(1),
        );
      },
    );
  });
}
