import 'package:flutter/material.dart';

part 'slider_clipper.dart';
part 'divider_painter.dart';

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
///    itemOne: const Image.asset('...'),
///    itemTwo: const Image.asset('...'),
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
    this.itemOneBuilder,
    this.itemTwoBuilder,
    this.changePositionOnHover = false,
    this.onPositionChange,
    this.position = 0.5,
    this.dividerColor = Colors.white,
    this.handleColor,
    this.handleOutlineColor,
    this.dividerWidth = 2.5,
    this.handleSize = const Size(20, 20),
    this.handleRadius = const BorderRadius.all(Radius.circular(10)),
    this.fillHandle = false,
    this.hideHandle = false,
    this.handlePosition = 0.5,
    this.handleFollowsPosition = false,
    this.direction = SliderDirection.leftToRight,
    this.photoRadius = BorderRadius.zero,
  })  : portrait = direction == SliderDirection.topToBottom ||
            direction == SliderDirection.bottomToTop,
        assert(
          dividerWidth >= 0,
          'dividerWidth must be greater or equal to 0',
        ),
        assert(
          position >= 0 && position <= 1,
          'initialPosition must be between 0 and 1',
        ),
        assert(
          handlePosition >= 0 && handlePosition <= 1,
          'handlePosition must be between 0 and 1',
        );

  /// First component to show in slider.
  final Image itemOne;

  /// Second component to show in slider.
  final Image itemTwo;

  /// Wrapper for the first component.
  final Widget Function(Widget child, BuildContext context)? itemOneBuilder;

  /// Wrapper for the second component.
  final Widget Function(Widget child, BuildContext context)? itemTwoBuilder;

  /// Whether the slider should follow the pointer on hover.
  final bool changePositionOnHover;

  /// Callback on position change, returns current position.
  final void Function(double position)? onPositionChange;

  /// Initial percentage position of divide (0-1).
  final double position;

  /// Color of the divider
  final Color dividerColor;

  /// Color of the divider
  final Color? handleColor;

  /// Color of the divider
  final Color? handleOutlineColor;

  /// Width of the divider
  final double dividerWidth;

  /// Handle size.
  final Size handleSize;

  /// Handle radius.
  final BorderRadius handleRadius;

  /// Wether to fill the handle.
  final bool fillHandle;

  /// Whether to hide the handle.
  final bool hideHandle;

  /// Where to place the handle.
  final double handlePosition;

  /// Wheter or not the handle should follow the position while dragging.
  final bool handleFollowsPosition;

  /// Direction of the slider.
  final SliderDirection direction;

  /// Whether to use portrait orientation.
  final bool portrait;

  /// Radius of the photo.
  final BorderRadiusGeometry photoRadius;

  // TODO(carlito): Implement these features.
  /// Whether to only handle drag events on the handle.
  // final bool onlyHandleDraggable;
  /// Whether to enable haptic feedback.
  // final bool hapticFeedbackEnabled;
  /// Type of haptic feedback.
  // final HapticFeedbackType hapticFeedbackType;

  @override
  State<ImageCompareSlider> createState() => _ImageCompareSliderState();
}

class _ImageCompareSliderState extends State<ImageCompareSlider> {
  late double position;
  late double handlePosition;

  void initPosition() => position = widget.position;
  void initHandlePosition() => handlePosition = widget.handlePosition;

  @override
  void didUpdateWidget(ImageCompareSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != oldWidget.position) initPosition();
    if (widget.handlePosition != oldWidget.handlePosition) initHandlePosition();
  }

  @override
  void initState() {
    super.initState();
    assert(
      widget.handleSize.width >= 0 && widget.handleSize.height >= 0,
      'handleSize must be greater or equal to 0',
    );
    initPosition();
    initHandlePosition();
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

    if (widget.handleFollowsPosition) {
      final handlePos = widget.portrait
          ? localPosition.dx / box.size.width
          : localPosition.dy / box.size.height;

      setState(() => handlePosition = handlePos);
    }

    updatePosition(newPosition);
  }

  Image generateImage(Image image) => Image(
        image: image.image,
        fit: image.fit,
        /* Gathered properties */
        color: image.color,
        colorBlendMode: image.colorBlendMode,
        alignment: image.alignment,
        loadingBuilder: image.loadingBuilder,
        frameBuilder: image.frameBuilder,
        errorBuilder: image.errorBuilder,
        excludeFromSemantics: image.excludeFromSemantics,
        filterQuality: image.filterQuality,
        gaplessPlayback: image.gaplessPlayback,
        isAntiAlias: image.isAntiAlias,
        matchTextDirection: image.matchTextDirection,
        opacity: image.opacity,
        repeat: image.repeat,
        semanticLabel: image.semanticLabel,
        width: image.width,
        height: image.height,
        /* Not used properties */
        // centerSlice: image.centerSlice,
      );

  @override
  Widget build(BuildContext context) {
    final generatedFirstImage = generateImage(widget.itemOne);
    final generatedSecondImage = generateImage(widget.itemTwo);
    final firstImage =
        widget.itemOneBuilder?.call(generatedFirstImage, context) ??
            generatedFirstImage;
    final secondImage =
        widget.itemTwoBuilder?.call(generatedSecondImage, context) ??
            generatedSecondImage;

    final child = ClipRRect(
      borderRadius: widget.photoRadius,
      child: GestureDetector(
        onTapDown: (details) => onDetection(details.globalPosition),
        onPanUpdate: (details) => onDetection(details.globalPosition),
        onPanEnd: (_) => updatePosition(position),
        child: Stack(
          children: [
            ClipRect(
              clipper: _SliderClipper.inverted(
                position: position,
                direction: widget.direction,
              ),
              child: firstImage,
            ),
            ClipRect(
              clipper: _SliderClipper(
                position: position,
                direction: widget.direction,
              ),
              child: secondImage,
            ),
            CustomPaint(
              painter: _DividerPainter(
                position: position,
                color: widget.dividerColor,
                handleColor: widget.handleColor ?? widget.dividerColor,
                handleOutlineColor: widget.handleOutlineColor ??
                    widget.handleColor ??
                    widget.dividerColor,
                strokeWidth: widget.dividerWidth,
                portrait: widget.portrait,
                fillHandle: widget.fillHandle,
                handleSize: widget.handleSize,
                hideHandle: widget.hideHandle,
                handlePosition: handlePosition,
                handleRadius: widget.handleRadius,
              ),
              child: Opacity(opacity: 0, child: secondImage),
            ),
          ],
        ),
      ),
    );

    return widget.changePositionOnHover
        ? MouseRegion(
            onHover: (event) => onDetection(event.position),
            child: child,
          )
        : child;
  }
}
