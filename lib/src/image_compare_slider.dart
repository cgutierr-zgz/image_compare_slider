// ignore_for_file: unused_import, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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
///    imageHeight: 500,
///    imageWidth: 500,
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
    required this.imageWidth,
    required this.imageHeight,
    required this.itemOne,
    required this.itemTwo,
    super.key,
    this.changePositionOnHover = false,
    this.handle,
    this.hideHandle = false,
    this.onPositionChange,
    this.direction = SliderDirection.leftToRight,
    this.position = 0.5,
    this.dividerColor = Colors.white,
    this.dividerWidth = 2.5,
  })  : portrait = direction == SliderDirection.topToBottom ||
            direction == SliderDirection.bottomToTop,
        assert(
          imageWidth > 0 && imageHeight > 0,
          'imageWidth and imageHeight must be greater than 0',
        ),
        assert(
          position >= 0 && position <= 1,
          'initialPosition must be between 0 and 1',
        ),
        assert(
          dividerWidth >= 0,
          'dividerWidth must be greater than 0',
        );

  /// Width of image.
  final double imageWidth;

  /// Height of image.
  final double imageHeight;

  /// Whether the slider should follow the pointer on hover.
  final bool changePositionOnHover;

  /// Custom handle component.
  final Widget? handle;

  /// Whether to hide the handle.
  final bool hideHandle;

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
    return SizedBox(
      height: widget.imageHeight,
      width: widget.imageWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final child = GestureDetector(
            onTapDown: (details) => onDetection(details.globalPosition),
            onPanUpdate: (details) => onDetection(details.globalPosition),
            onPanEnd: (_) => updatePosition(position),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image(
                    image: widget.itemOne,
                    fit: BoxFit.cover,
                    width: widget.imageWidth,
                    height: widget.imageHeight,
                  ),
                ),
                Positioned.fill(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRect(
                        clipper: _SliderClipper(
                          position: position,
                          direction: widget.direction,
                        ),
                        child: Image(
                          image: widget.itemTwo,
                          fit: BoxFit.cover,
                          width: widget.imageWidth,
                          height: widget.imageHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                buildHandle(constraints),
              ],
            ),
          );

          return widget.changePositionOnHover
              ? MouseRegion(
                  onHover: (event) => onDetection(event.position),
                  child: child,
                )
              : child;
        },
      ),
    );
  }

  double getSliderSize(BoxConstraints constraints) {
    if (widget.portrait) return constraints.maxHeight;

    return constraints.maxWidth;
  }

  Widget buildHandle(BoxConstraints constraints) {
    const handleSize = 50.0;
    final handleOffset =
        position * getSliderSize(constraints) - (handleSize / 2);

    final line = Expanded(
      child: Container(
        width: widget.portrait ? null : widget.dividerWidth,
        height: widget.portrait ? widget.dividerWidth : null,
        color: widget.dividerColor,
      ),
    );

    final handle = SizedBox(
      height: widget.portrait ? handleSize : null,
      width: widget.portrait ? null : handleSize,
      child: widget.hideHandle
          ? null
          : widget.handle ??
              Container(
                alignment: Alignment.center,
                width: handleSize,
                height: handleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.dividerColor,
                    width: widget.dividerWidth,
                  ),
                ),
                child: Transform.rotate(
                  angle: widget.portrait ? 0 : -pi / 2,
                  child: Icon(Icons.unfold_more, color: widget.dividerColor),
                ),
              ),
    );

    final children = <Widget>[line, handle, line];

    return Positioned(
      top: widget.portrait ? handleOffset : 0,
      left: widget.portrait ? 0 : handleOffset,
      right: widget.portrait ? 0 : null,
      bottom: widget.portrait ? null : 0,
      child: widget.portrait
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
    );
  }
}

class _SliderClipper extends CustomClipper<Rect> {
  _SliderClipper({required this.position, required this.direction});

  final double position;
  final SliderDirection direction;

  @override
  Rect getClip(Size size) {
    switch (direction) {
      case SliderDirection.leftToRight:
        final dx = position * size.width;
        return Rect.fromLTRB(0, 0, dx, size.height);
      case SliderDirection.rightToLeft:
        final dx = position * size.width;
        return Rect.fromLTRB(dx, 0, size.width, size.height);
      case SliderDirection.topToBottom:
        final dy = position * size.height;
        return Rect.fromLTRB(0, 0, size.width, dy);
      case SliderDirection.bottomToTop:
        final dy = position * size.height;
        return Rect.fromLTRB(0, dy, size.width, size.height);
    }
  }

  @override
  bool shouldReclip(_SliderClipper oldClipper) =>
      oldClipper.position != position || oldClipper.direction != direction;
}
