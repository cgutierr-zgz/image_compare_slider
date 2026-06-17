import 'package:flutter/material.dart';

import 'package:image_compare_slider/src/image_compare_controller.dart';

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

/// Builder for a fully custom handle widget.
///
/// Receives the [BuildContext], the current divider [position] (0-1) and
/// whether the slider is laid out in [portrait] orientation. Return any widget;
/// it is centered on the handle anchor and is draggable to move the slider.
typedef HandleBuilder = Widget Function(
  BuildContext context,
  double position,
  // Positional bool reads fine here: handle builders are short closures where
  // `(context, position, portrait)` is the conventional, readable signature.
  // ignore: avoid_positional_boolean_parameters
  bool portrait,
);

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
///
/// On top of the slider it supports:
/// * **Zoom & pan** ([zoomable]/[pannable]) applied to *both* images at once so
///   they stay aligned while comparing.
/// * **Rotation with lock** via an [ImageCompareSliderController] — rotate each
///   image independently, or lock them to rotate together.
/// * **Custom handles** via [handleBuilder].
/// * **Size matching** of differently-sized images via [fit] + [aspectRatio].
///
/// See also:
/// * [SliderDirection] for the direction of the slider.
/// * [ImageCompareSliderController] to drive zoom/pan/rotation/position.
/// {@endtemplate}
class ImageCompareSlider extends StatefulWidget {
  /// Creates a [ImageCompareSlider].
  ///
  /// {@macro flutter_compare_slider}
  const ImageCompareSlider({
    required this.itemOne,
    required this.itemTwo,
    super.key,
    this.controller,
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
    this.handleBuilder,
    this.onlyHandleDraggable = false,
    this.direction = SliderDirection.leftToRight,
    this.photoRadius = BorderRadius.zero,
    this.fit = BoxFit.contain,
    this.aspectRatio,
    this.zoomable = false,
    this.pannable = false,
    this.enableGestureRotation = false,
    this.doubleTapToZoom = true,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.doubleTapScale = 2.5,
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
        ),
        assert(minScale > 0, 'minScale must be greater than 0'),
        assert(maxScale >= minScale, 'maxScale must be >= minScale'),
        assert(
          aspectRatio == null || aspectRatio > 0,
          'aspectRatio must be greater than 0',
        );

  /// Optional controller driving position, zoom, pan and rotation.
  ///
  /// If omitted, an internal controller is created from [position] and the
  /// scale bounds. Provide your own to rotate images, lock rotation, zoom or
  /// reset programmatically.
  final ImageCompareSliderController? controller;

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

  /// Builds a custom handle widget, centered on the handle anchor.
  ///
  /// When provided, the painted circular handle is replaced by this widget
  /// (the divider line is still drawn). The returned widget is draggable.
  final HandleBuilder? handleBuilder;

  /// When `true`, the slider position only changes by dragging the handle
  /// (or via the [controller]); dragging or tapping elsewhere won't move it.
  ///
  /// This is forced on while [zoomable]/[pannable] are active so single-finger
  /// drags pan the images instead of fighting the slider.
  final bool onlyHandleDraggable;

  /// Direction of the slider.
  final SliderDirection direction;

  /// Whether to use portrait orientation.
  final bool portrait;

  /// Radius of the photo.
  final BorderRadiusGeometry photoRadius;

  /// How both images are inscribed into their box. Use [BoxFit.cover] together
  /// with [aspectRatio] to make differently-sized images line up.
  final BoxFit fit;

  /// When set, the slider is wrapped in an [AspectRatio] and both images are
  /// forced to fill the same box, so images of different intrinsic sizes are
  /// matched. When `null`, the slider sizes itself to its content (legacy
  /// behaviour).
  final double? aspectRatio;

  /// Enables pinch-to-zoom (and double-tap zoom if [doubleTapToZoom]) applied
  /// to both images at once.
  final bool zoomable;

  /// Enables dragging to pan both images. Implied while zoomed in.
  final bool pannable;

  /// Enables two-finger rotation gestures (rotates both images together).
  final bool enableGestureRotation;

  /// Whether a double-tap toggles zoom between [minScale] and [doubleTapScale].
  final bool doubleTapToZoom;

  /// Minimum zoom factor.
  final double minScale;

  /// Maximum zoom factor.
  final double maxScale;

  /// Zoom factor applied on double-tap.
  final double doubleTapScale;

  @override
  State<ImageCompareSlider> createState() => _ImageCompareSliderState();
}

class _ImageCompareSliderState extends State<ImageCompareSlider> {
  late ImageCompareSliderController _controller;
  bool _ownsController = false;

  late double handlePosition;

  /// The actual rendered size of the widget, read from its render object. This
  /// is the same reference [onDetection] uses, so the handle and divider always
  /// agree (unlike `LayoutBuilder` constraints, which can be looser).
  Size? get _renderSize {
    final box = context.findRenderObject() as RenderBox?;
    return (box != null && box.hasSize) ? box.size : null;
  }

  // Gesture bookkeeping.
  double _gestureStartScale = 1;
  double _gesturePreviousRotation = 0;
  bool _draggingHandle = false;

  bool get _interactive => widget.zoomable || widget.pannable;

  ImageCompareSliderController _createController() =>
      ImageCompareSliderController(
        position: widget.position,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
      );

  @override
  void initState() {
    super.initState();
    assert(
      widget.handleSize.width >= 0 && widget.handleSize.height >= 0,
      'handleSize must be greater or equal to 0',
    );
    handlePosition = widget.handlePosition;
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = _createController();
      _ownsController = true;
    }
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(ImageCompareSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      if (_ownsController && oldWidget.controller == null) {
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownsController = false;
      } else {
        _controller = _createController();
        _ownsController = true;
      }
      _controller.addListener(_onControllerChanged);
    }

    // Only mirror the `position` prop into an internally-owned controller; if
    // the user supplied a controller, it is the source of truth.
    if (_ownsController && widget.position != oldWidget.position) {
      _controller.position = widget.position;
    }
    if (widget.handlePosition != oldWidget.handlePosition) {
      handlePosition = widget.handlePosition;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void updatePosition(double newPosition) {
    _controller.position = newPosition;
    widget.onPositionChange?.call(_controller.position);
  }

  void onDetection(Offset globalPosition) {
    // Safe: onDetection only runs from gesture callbacks, by which point the
    // element is mounted and laid out, so the render object is a RenderBox.
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

      setState(() => handlePosition = handlePos.clamp(0.0, 1.0));
    }

    updatePosition(newPosition);
  }

  Image generateImage(Image image) => Image(
        image: image.image,
        fit: widget.fit,
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
      );

  /// Applies the shared zoom/pan and the per-image rotation.
  Widget _withTransform(Widget child, double rotation) {
    final offset = _controller.offset;
    final scale = _controller.scale;
    final matrix = Matrix4.translationValues(offset.dx, offset.dy, 0)
      ..multiply(Matrix4.diagonal3Values(scale, scale, 1));

    return Transform(
      transform: matrix,
      alignment: Alignment.center,
      filterQuality: FilterQuality.medium,
      child: rotation == 0
          ? child
          : Transform.rotate(angle: rotation, child: child),
    );
  }

  Offset _handleCenter(Size size) {
    final pos = _controller.position;
    return widget.portrait
        ? Offset(size.width * handlePosition, size.height * pos)
        : Offset(size.width * pos, size.height * handlePosition);
  }

  Offset _clampOffset(Offset offset) {
    final size = _renderSize;
    if (size == null) return offset;
    // Allow panning within the extra space created by zooming in.
    final maxX =
        (size.width * (_controller.scale - 1)).clamp(0.0, double.infinity) / 2 +
            size.width / 2;
    final maxY =
        (size.height * (_controller.scale - 1)).clamp(0.0, double.infinity) /
                2 +
            size.height / 2;
    return Offset(
      offset.dx.clamp(-maxX, maxX),
      offset.dy.clamp(-maxY, maxY),
    );
  }

  /// Whether [localFocal] (local to the gesture detector) is on the handle's
  /// touch target.
  bool _isOnHandle(Offset localFocal) {
    final size = _renderSize;
    if (size == null || widget.hideHandle) return false;

    final center = _handleCenter(size);
    final hitWidth = _handleHitSize().width;
    final hitHeight = _handleHitSize().height;
    final rect = Rect.fromCenter(
      center: center,
      width: hitWidth,
      height: hitHeight,
    );
    return rect.contains(localFocal);
  }

  Size _handleHitSize() {
    final w =
        (widget.portrait ? widget.handleSize.height : widget.handleSize.width)
            .clamp(48.0, double.infinity);
    final h =
        (widget.portrait ? widget.handleSize.width : widget.handleSize.height)
            .clamp(48.0, double.infinity);
    return Size(w, h);
  }

  // --- Gestures -------------------------------------------------------------

  void _onScaleStart(ScaleStartDetails details) {
    _gestureStartScale = _controller.scale;
    _gesturePreviousRotation = 0;
    // A single-pointer drag that starts on the handle always moves the slider,
    // even when zoom/pan are enabled.
    _draggingHandle =
        details.pointerCount == 1 && _isOnHandle(details.localFocalPoint);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    // Dragging the handle moves the slider regardless of the other modes.
    if (_draggingHandle && details.pointerCount == 1) {
      onDetection(details.focalPoint);
      return;
    }

    // Legacy behaviour: with no interaction enabled, a drag anywhere moves the
    // slider (unless restricted to the handle).
    if (!_interactive) {
      if (!widget.onlyHandleDraggable) onDetection(details.focalPoint);
      return;
    }

    if (widget.zoomable && details.pointerCount >= 2) {
      _controller.scale = (_gestureStartScale * details.scale)
          .clamp(widget.minScale, widget.maxScale);

      if (widget.enableGestureRotation) {
        final rotationDelta = details.rotation - _gesturePreviousRotation;
        _gesturePreviousRotation = details.rotation;
        _controller.rotateBoth(rotationDelta);
      }
    }

    final canPan = widget.pannable ||
        (widget.zoomable && _controller.scale > widget.minScale);
    if (canPan && details.focalPointDelta != Offset.zero) {
      _controller.offset =
          _clampOffset(_controller.offset + details.focalPointDelta);
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (!_interactive && !widget.onlyHandleDraggable) {
      onDetection(details.globalPosition);
    }
  }

  void _onDoubleTap() {
    if (!widget.zoomable || !widget.doubleTapToZoom) return;
    if (_controller.scale > widget.minScale) {
      _controller
        ..scale = widget.minScale
        ..offset = Offset.zero;
    } else {
      _controller.scale =
          widget.doubleTapScale.clamp(widget.minScale, widget.maxScale);
    }
  }

  // --- Build ----------------------------------------------------------------

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

    final matchSizes = widget.aspectRatio != null;
    final usingCustomHandle = widget.handleBuilder != null;

    final stack = Stack(
      fit: matchSizes ? StackFit.expand : StackFit.loose,
      children: [
        ClipRect(
          clipper: _SliderClipper.inverted(
            position: _controller.position,
            direction: widget.direction,
          ),
          child: _withTransform(firstImage, _controller.rotationOne),
        ),
        ClipRect(
          clipper: _SliderClipper(
            position: _controller.position,
            direction: widget.direction,
          ),
          child: _withTransform(secondImage, _controller.rotationTwo),
        ),
        CustomPaint(
          painter: _DividerPainter(
            position: _controller.position,
            color: widget.dividerColor,
            handleColor: widget.handleColor ?? widget.dividerColor,
            handleOutlineColor: widget.handleOutlineColor ??
                widget.handleColor ??
                widget.dividerColor,
            strokeWidth: widget.dividerWidth,
            portrait: widget.portrait,
            fillHandle: widget.fillHandle,
            handleSize: widget.handleSize,
            // Hide the painted handle when a custom one is provided.
            hideHandle: widget.hideHandle || usingCustomHandle,
            handlePosition: handlePosition,
            handleRadius: widget.handleRadius,
          ),
          child: Opacity(opacity: 0, child: secondImage),
        ),
        if (usingCustomHandle && !widget.hideHandle) _buildCustomHandle(),
      ],
    );

    final gestureChild = GestureDetector(
      onTapDown: _onTapDown,
      onDoubleTap:
          widget.zoomable && widget.doubleTapToZoom ? _onDoubleTap : null,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: stack,
    );

    final clipped = ClipRRect(
      borderRadius: widget.photoRadius,
      child: gestureChild,
    );

    final sized = matchSizes
        ? AspectRatio(aspectRatio: widget.aspectRatio!, child: clipped)
        : clipped;

    return widget.changePositionOnHover
        ? MouseRegion(
            onHover: (event) {
              if (!widget.onlyHandleDraggable) onDetection(event.position);
            },
            child: sized,
          )
        : sized;
  }

  /// Visual-only overlay for a custom handle. Pointer events pass through to
  /// the single gesture detector, which routes handle-area drags to the slider
  /// via [_isOnHandle].
  ///
  /// Laid out with a [CustomSingleChildLayout] so the handle's *centre* lands
  /// exactly on `size * position` — the same point the divider is painted at —
  /// regardless of the handle's own size (a fractional [Alignment] would inset
  /// the child by half its size near the edges and drift off the line).
  Widget _buildCustomHandle() {
    final pos = _controller.position;
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomSingleChildLayout(
          delegate: _HandleLayoutDelegate(
            position: pos,
            handlePosition: handlePosition,
            portrait: widget.portrait,
          ),
          child: widget.handleBuilder!(context, pos, widget.portrait),
        ),
      ),
    );
  }
}

/// Centres the custom handle on the divider anchor, independent of its size.
class _HandleLayoutDelegate extends SingleChildLayoutDelegate {
  const _HandleLayoutDelegate({
    required this.position,
    required this.handlePosition,
    required this.portrait,
  });

  final double position;
  final double handlePosition;
  final bool portrait;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final cx = portrait ? size.width * handlePosition : size.width * position;
    final cy = portrait ? size.height * position : size.height * handlePosition;
    return Offset(cx - childSize.width / 2, cy - childSize.height / 2);
  }

  @override
  bool shouldRelayout(_HandleLayoutDelegate old) =>
      old.position != position ||
      old.handlePosition != handlePosition ||
      old.portrait != portrait;
}
