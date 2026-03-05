import 'dart:math' as math;
import 'package:flutter/material.dart';

class RadialLayoutManager {
  static final RadialLayoutManager instance = RadialLayoutManager._internal();
  RadialLayoutManager._internal();

  final List<Rect> _rects = [];
  // Our infinite canvas center
  final double center = 3000.0;

  /// Ensures we have exactly [count] items mapped.
  void ensureCalculated(int count) {
    while (_rects.length < count) {
      _calculateNextRect();
    }
  }

  /// Returns the bounding box Rect for the exact index.
  Rect getRectForIndex(int index) {
    ensureCalculated(index + 1);
    return _rects[index];
  }

  /// Calculates which items are visible inside the [viewport] rect.
  List<int> getVisibleIndices(Rect viewport, int itemCount) {
    ensureCalculated(itemCount);

    final List<int> visible = [];
    // Expand viewport mildly to buffer items just outside the screen so they don't pop in
    final Rect paddedViewport = viewport.inflate(500.0);

    for (int i = 0; i < itemCount; i++) {
      if (paddedViewport.overlaps(_rects[i])) {
        visible.add(i);
      }
    }
    return visible;
  }

  void _calculateNextRect() {
    int i = _rects.length;
    final random = math.Random(i + 12345); // Deterministic

    // Constant width
    final double width = 280.0;
    // Masonry varied height (200 ~ 400)
    final double height = 200.0 + random.nextInt(200);

    if (i == 0) {
      _rects.add(
        Rect.fromCenter(
          center: Offset(center, center),
          width: width,
          height: height,
        ),
      );
      return;
    }

    double a = 0.0;
    double b = 20.0; // Spiraling out radius scalar

    // Golden ratio spread
    double startTheta = i * 137.508 * (math.pi / 180.0);
    double theta = startTheta;

    while (true) {
      // Current radius grows as theta increases from startTheta
      double r = a + b * ((theta - startTheta) / (math.pi * 2));
      double cx = center + r * math.cos(theta);
      double cy = center + r * math.sin(theta);

      Rect candidate = Rect.fromCenter(
        center: Offset(cx, cy),
        width: width,
        height: height,
      );

      // We want a gap of 10px between blocks, so inflate by 5px for collision
      Rect candidateBound = candidate.inflate(5.0);

      bool intersects = false;
      // Loop backwards - higher chance to hit outer ring collisions early
      for (int j = _rects.length - 1; j >= 0; j--) {
        if (_rects[j].inflate(5.0).overlaps(candidateBound)) {
          intersects = true;
          break;
        }
      }

      if (!intersects) {
        _rects.add(candidate);
        break;
      }

      // Step outward
      double step = math.max(0.1, 80.0 / math.max(1, r));
      theta += step;
    }
  }

  void reset() {
    _rects.clear();
  }
}
