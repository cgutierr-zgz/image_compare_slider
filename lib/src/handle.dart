part of 'image_compare_slider.dart';

class _Handle extends StatelessWidget {
  const _Handle({
    required this.position,
    required this.dividerColor,
    required this.dividerWidth,
    required this.portrait,
    required this.constraints,
    required this.hideHandle,
    required this.handle,
  });

  final double position;
  final Color dividerColor;
  final double dividerWidth;
  final bool portrait;
  final BoxConstraints constraints;
  final bool hideHandle;
  final Widget? handle;

  static const handleSize = 50.0;

  double getSliderSize(BoxConstraints constraints) {
    if (portrait) return constraints.maxHeight;

    return constraints.maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    final handleOffset =
        position * getSliderSize(constraints) - (handleSize / 2);

    final line = Expanded(
      child: Container(
        width: portrait ? null : dividerWidth,
        height: portrait ? dividerWidth : null,
        color: dividerColor,
      ),
    );

    final handleWidget = SizedBox(
      height: portrait ? handleSize : null,
      width: portrait ? null : handleSize,
      child: hideHandle
          ? null
          : handle ??
              Container(
                alignment: Alignment.center,
                width: handleSize,
                height: handleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: dividerColor,
                    width: dividerWidth,
                  ),
                ),
                child: Transform.rotate(
                  angle: portrait ? 0 : -pi / 2,
                  child: Icon(Icons.unfold_more, color: dividerColor),
                ),
              ),
    );

    final children = <Widget>[line, handleWidget, line];

    return Positioned(
      top: portrait ? handleOffset : 0,
      left: portrait ? 0 : handleOffset,
      right: portrait ? 0 : null,
      bottom: portrait ? null : 0,
      child: portrait
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
