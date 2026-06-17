import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Holds and drives the interactive state of an `ImageCompareSlider`.
///
/// A controller owns everything the user can manipulate at runtime:
///
/// * [position] — where the divider sits (0-1).
/// * [scale] / [offset] — the shared zoom & pan applied to *both* images so
///   they stay perfectly aligned while comparing.
/// * [rotationOne] / [rotationTwo] — per-image rotation, in radians.
/// * [lockRotation] — when `true`, rotating one image rotates the other by the
///   same delta so they stay in the same rotation cycle.
///
/// Pass a controller to `ImageCompareSlider` to drive these values
/// programmatically (e.g. rotate buttons, a reset action, animated zoom). If
/// you don't pass one, the widget creates and manages an internal controller
/// seeded from its constructor arguments.
///
/// ```dart
/// final controller = ImageCompareSliderController();
/// // Rotate the left image 90° clockwise (and the right one too if locked).
/// controller.rotateOne(math.pi / 2);
/// // Zoom both images to 2x.
/// controller.scale = 2;
/// // Back to the initial state.
/// controller.reset();
/// ```
///
/// Remember to [dispose] controllers you create yourself.
class ImageCompareSliderController extends ChangeNotifier {
  /// Creates a controller with optional initial values.
  ImageCompareSliderController({
    double position = 0.5,
    double scale = 1,
    Offset offset = Offset.zero,
    double rotationOne = 0,
    double rotationTwo = 0,
    bool lockRotation = false,
    this.minScale = 1,
    this.maxScale = 5,
  })  : assert(
          position >= 0 && position <= 1,
          'position must be between 0 and 1',
        ),
        assert(minScale > 0, 'minScale must be greater than 0'),
        assert(maxScale >= minScale, 'maxScale must be >= minScale'),
        _position = position,
        _scale = scale.clamp(minScale, maxScale),
        _offset = offset,
        _rotationOne = rotationOne,
        _rotationTwo = rotationTwo,
        _lockRotation = lockRotation,
        _initial = _InitialState(
          position: position,
          scale: scale.clamp(minScale, maxScale),
          offset: offset,
          rotationOne: rotationOne,
          rotationTwo: rotationTwo,
        );

  final _InitialState _initial;

  /// Lower bound for [scale].
  final double minScale;

  /// Upper bound for [scale].
  final double maxScale;

  double _position;
  double _scale;
  Offset _offset;
  double _rotationOne;
  double _rotationTwo;
  bool _lockRotation;

  /// Divider position, between 0 and 1.
  double get position => _position;
  set position(double value) {
    final clamped = value.clamp(0.0, 1.0);
    if (clamped == _position) return;
    _position = clamped;
    notifyListeners();
  }

  /// Shared zoom factor applied to both images.
  double get scale => _scale;
  set scale(double value) {
    final clamped = value.clamp(minScale, maxScale);
    if (clamped == _scale) return;
    _scale = clamped;
    notifyListeners();
  }

  /// Shared pan offset (in logical pixels) applied to both images.
  Offset get offset => _offset;
  set offset(Offset value) {
    if (value == _offset) return;
    _offset = value;
    notifyListeners();
  }

  /// Rotation of the first image, in radians.
  double get rotationOne => _rotationOne;
  set rotationOne(double value) {
    if (value == _rotationOne) return;
    _rotationOne = value;
    notifyListeners();
  }

  /// Rotation of the second image, in radians.
  double get rotationTwo => _rotationTwo;
  set rotationTwo(double value) {
    if (value == _rotationTwo) return;
    _rotationTwo = value;
    notifyListeners();
  }

  /// Whether both images rotate together.
  ///
  /// When toggled on, the two images keep their *current* individual angles;
  /// subsequent rotations are applied to both. Use [matchRotation] to snap them
  /// to the same angle.
  bool get lockRotation => _lockRotation;
  set lockRotation(bool value) {
    if (value == _lockRotation) return;
    _lockRotation = value;
    notifyListeners();
  }

  /// Rotates the first image by [radians] (clockwise positive).
  ///
  /// If [lockRotation] is on, the second image rotates by the same amount.
  void rotateOne(double radians) {
    _rotationOne += radians;
    if (_lockRotation) _rotationTwo += radians;
    notifyListeners();
  }

  /// Rotates the second image by [radians] (clockwise positive).
  ///
  /// If [lockRotation] is on, the first image rotates by the same amount.
  void rotateTwo(double radians) {
    _rotationTwo += radians;
    if (_lockRotation) _rotationOne += radians;
    notifyListeners();
  }

  /// Rotates both images by [radians] regardless of [lockRotation].
  void rotateBoth(double radians) {
    _rotationOne += radians;
    _rotationTwo += radians;
    notifyListeners();
  }

  /// Snaps the second image to the first image's angle (or vice-versa).
  void matchRotation({bool toFirst = true}) {
    if (toFirst) {
      _rotationTwo = _rotationOne;
    } else {
      _rotationOne = _rotationTwo;
    }
    notifyListeners();
  }

  /// Multiplies the current [scale] by [factor], clamped to the bounds.
  void zoomBy(double factor) => scale = _scale * factor;

  /// Adds [delta] to the current [offset].
  void panBy(Offset delta) => offset = _offset + delta;

  /// Resets zoom, pan and rotation (and optionally [position]) to the values
  /// the controller was created with.
  void reset({bool resetPosition = false}) {
    _scale = _initial.scale;
    _offset = _initial.offset;
    _rotationOne = _initial.rotationOne;
    _rotationTwo = _initial.rotationTwo;
    if (resetPosition) _position = _initial.position;
    notifyListeners();
  }

  /// Convenience: a quarter-turn clockwise.
  static const double quarterTurn = math.pi / 2;
}

class _InitialState {
  const _InitialState({
    required this.position,
    required this.scale,
    required this.offset,
    required this.rotationOne,
    required this.rotationTwo,
  });

  final double position;
  final double scale;
  final Offset offset;
  final double rotationOne;
  final double rotationTwo;
}
