import 'package:flutter/material.dart';

part 'slider_clipper.dart';
part 'handle_painter.dart';

/// Slider direction.
enum SliderDirection {
  /// Slider direction from left to right.
  leftToRight,

  /// Slider direction from right to left.
  rightToLeft,

  /// Slider direction from top to bottom.
  topToBottom,

  /// Slider direction from bottom to top.
  bottomToTop,
}

/// {@template flutter_compare_slider}
///  A Flutter widget that allows you to compare two images.
///
/// Usage:
/// ```dart
///  ImageCompareSlider(
///    itemOne: const AssetImage('assets/render.png'),
///    itemTwo: const AssetImage('assets/render_oc.png'),
///  )
/// ```
/// See also:
/// * [SliderDirection] for the direction of the slider.
/// {@endtemplate}
class ImageCompareSlider extends StatefulWidget {
  /// Creates a [ImageCompareSlider].
  ///
  /// {@macro flutter_compare_slider}
  const ImageCompareSlider({
    required this.itemOne,
    required this.itemTwo,
    super.key,
    this.changePositionOnHover = false,
    this.handleRadius = 20,
    this.fillHandle = false,
    this.hideHandle = false,
    this.handlePosition = 0.5,
    this.onPositionChange,
    this.direction = SliderDirection.leftToRight,
    this.position = 0.5,
    this.dividerColor = Colors.white,
    this.dividerWidth = 2.5,
  })  : portrait = direction == SliderDirection.topToBottom ||
            direction == SliderDirection.bottomToTop,
        assert(
          position >= 0 && position <= 1,
          'initialPosition must be between 0 and 1',
        ),
        assert(
          handlePosition >= 0 && handlePosition <= 1,
          'handlePosition must be between 0 and 1',
        ),
        assert(
          dividerWidth >= 0,
          'dividerWidth must be greater than 0',
        ),
        assert(
          handleRadius >= 0,
          'handleRadius must be greater or equal to 0',
        );

  /// Whether the slider should follow the pointer on hover.
  final bool changePositionOnHover;

  /// Handle size.
  final double handleRadius;

  /// Wether to fill the handle.
  final bool fillHandle;

  /// Whether to hide the handle.
  final bool hideHandle;

  /// Where to place the handle.
  final double handlePosition;

  /// First component to show in slider.
  final ImageProvider<Object> itemOne;

  /// Second component to show in slider.
  final ImageProvider<Object> itemTwo;

  /// Callback on position change, returns current position.
  final void Function(double position)? onPositionChange;

  /// Whether to use portrait orientation.
  final bool portrait;

  /// Direction of the slider.
  final SliderDirection direction;

  /// Initial percentage position of divide (0-1).
  final double position;

  /// Color of the divider
  final Color dividerColor;

  /// Width of the divider
  final double dividerWidth;

  @override
  State<ImageCompareSlider> createState() => _ImageCompareSliderState();
}

class _ImageCompareSliderState extends State<ImageCompareSlider> {
  late double position;

  void initPosition() => position = widget.position;

  @override
  void didUpdateWidget(ImageCompareSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != oldWidget.position) initPosition();
  }

  @override
  void initState() {
    super.initState();
    initPosition();
  }

  void updatePosition(double newPosition) {
    setState(() => position = newPosition);
    widget.onPositionChange?.call(position);
  }

  void onDetection(Offset globalPosition) {
    // ignore: cast_nullable_to_non_nullable
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);
    var newPosition = widget.portrait
        ? localPosition.dy / box.size.height
        : localPosition.dx / box.size.width;
    newPosition = newPosition.clamp(0.0, 1.0);
    updatePosition(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    final child = Stack(
      children: [
        Image(image: widget.itemOne, fit: BoxFit.cover),
        ClipRect(
          clipper: _SliderClipper(
            position: position,
            direction: widget.direction,
          ),
          child: Image(image: widget.itemTwo, fit: BoxFit.cover),
        ),
        GestureDetector(
          onTapDown: (details) => onDetection(details.globalPosition),
          onPanUpdate: (details) => onDetection(details.globalPosition),
          onPanEnd: (_) => updatePosition(position),
          child: CustomPaint(
            painter: _HandlePainter(
              position: position,
              color: widget.dividerColor,
              strokeWidth: widget.dividerWidth,
              portrait: widget.portrait,
              fillHandle: widget.fillHandle,
              handleRadius: widget.handleRadius,
              hideHandle: widget.hideHandle,
              handlePosition: widget.handlePosition,
            ),
            child: Opacity(
              opacity: 0,
              child: Image(image: widget.itemOne, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );

    return widget.changePositionOnHover
        ? MouseRegion(
            onHover: (event) => onDetection(event.position),
            child: child,
          )
        : child;
  }
}
