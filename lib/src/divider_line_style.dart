import 'dart:ui' show StrokeCap;

import 'package:flutter/foundation.dart';

/// Describes how the divider line of an `ImageCompareSlider` is stroked.
///
/// The line can be **solid**, **dashed**, **dotted**, or follow a fully custom
/// dash [pattern]. This only affects the painted divider line; the handle and
/// its outline are unaffected.
///
/// ### Quick start
///
/// ```dart
/// ImageCompareSlider(
///   itemOne: const Image.asset('...'),
///   itemTwo: const Image.asset('...'),
///   dividerLineStyle: DividerLineStyle.dashed(),
/// )
/// ```
///
/// ### Presets
///
/// * [DividerLineStyle.solid] — an unbroken line (the default).
/// * [DividerLineStyle.dashed] — evenly spaced dashes of `dashLength` separated
///   by `gapLength`.
/// * [DividerLineStyle.dotted] — round dots whose diameter equals the
///   `dividerWidth`, separated by `gapLength`.
///
/// ### Fully custom patterns
///
/// Use the default constructor with a [pattern] to build any repeating
/// dash/gap sequence. The list is read as alternating *on* (drawn) and *off*
/// (skipped) lengths in logical pixels, starting with an *on* segment:
///
/// ```dart
/// // Long dash, short gap, short dash, short gap, then repeat.
/// const DividerLineStyle(pattern: [12, 4, 4, 4]);
/// ```
///
/// A `0`-length *on* segment combined with [StrokeCap.round] renders a dot,
/// which is exactly how [DividerLineStyle.dotted] is implemented.
@immutable
class DividerLineStyle {
  /// Creates a divider line style from a raw dash [pattern].
  ///
  /// The [pattern] is a list of alternating *on* / *off* lengths (in logical
  /// pixels), starting with an *on* (drawn) segment. An empty list (the
  /// default) draws a solid, unbroken line.
  ///
  /// Every entry should be `>= 0`, and at least one *off* (gap) entry should be
  /// `> 0` so the pattern makes progress along the line. For best results,
  /// provide an even number of entries (on/off pairs).
  const DividerLineStyle({
    this.pattern = const <double>[],
    this.strokeCap = StrokeCap.butt,
  });

  /// A solid, unbroken line. This is the default style.
  const DividerLineStyle.solid({StrokeCap strokeCap = StrokeCap.butt})
      : this(strokeCap: strokeCap);

  /// A dashed line.
  ///
  /// Draws dashes of [dashLength] separated by gaps of [gapLength] (both in
  /// logical pixels). Defaults to a `8`/`5` dash/gap rhythm.
  ///
  /// Use [strokeCap] to round or square the ends of each dash.
  DividerLineStyle.dashed({
    double dashLength = 8,
    double gapLength = 5,
    this.strokeCap = StrokeCap.butt,
  })  : assert(dashLength >= 0, 'dashLength must be >= 0'),
        assert(gapLength > 0, 'gapLength must be > 0'),
        pattern = <double>[dashLength, gapLength];

  /// A dotted line.
  ///
  /// Renders round dots separated by gaps of [gapLength] (in logical pixels).
  /// Each dot's diameter equals the slider's `dividerWidth`, so a wider divider
  /// yields bigger dots. Defaults to a `6` logical-pixel gap.
  DividerLineStyle.dotted({double gapLength = 6})
      : assert(gapLength > 0, 'gapLength must be > 0'),
        pattern = <double>[0, gapLength],
        strokeCap = StrokeCap.round;

  /// The repeating dash pattern as alternating *on* / *off* lengths in logical
  /// pixels, starting with an *on* (drawn) segment.
  ///
  /// An empty list means the line is solid.
  final List<double> pattern;

  /// The cap applied to the ends of each drawn segment (and the shape of dots).
  final StrokeCap strokeCap;

  /// Whether this style draws a solid, unbroken line.
  bool get isSolid => pattern.isEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DividerLineStyle &&
          runtimeType == other.runtimeType &&
          strokeCap == other.strokeCap &&
          listEquals(pattern, other.pattern);

  @override
  int get hashCode => Object.hash(strokeCap, Object.hashAll(pattern));

  @override
  String toString() =>
      'DividerLineStyle(pattern: $pattern, strokeCap: $strokeCap)';
}
