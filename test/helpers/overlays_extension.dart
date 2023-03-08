import 'package:flame/game.dart';
import 'package:flutter/material.dart';

extension FlamePinballX on Game {
  void withFakeOverlay(String id) {
    overlays.addEntry(id, (_, __) => const SizedBox());
  }
}
