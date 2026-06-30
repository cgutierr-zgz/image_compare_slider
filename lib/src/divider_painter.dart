part of 'image_compare_slider.dart';

class _DividerPainter extends CustomPainter {
  const _DividerPainter({
    required this.position,
    required this.color,
    required this.handleColor,
    required this.handleOutlineColor,
    required this.strokeWidth,
    required this.lineStyle,
    required this.portrait,
    required this.hideHandle,
    required this.handlePosition,
    required this.fillHandle,
    required this.handleSize,
    required this.handleRadius,
  });

  final double position;
  final Color color;
  final Color handleColor;
  final Color handleOutlineColor;
  final double strokeWidth;
  final DividerLineStyle lineStyle;
  final bool portrait;
  final bool hideHandle;
  final bool fillHandle;
  final double handlePosition;
  final Size handleSize;
  final BorderRadius handleRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final color = strokeWidth == 0.0000 ? Colors.transparent : this.color;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = lineStyle.strokeCap;

    final dx = portrait ? size.width * handlePosition : size.width * position;
    final dy = portrait ? size.height * position : size.height * handlePosition;
    final handle = hideHandle
        ? Size.zero
        : portrait
            ? Size(handleSize.height, handleSize.width)
            : Size(handleSize.width, handleSize.height);

    _drawLine(
      canvas,
      portrait ? Offset(0, dy) : Offset(dx, 0),
      portrait
          ? Offset(dx - handle.width / 2, dy)
          : Offset(dx, dy - handle.height / 2),
      paint,
    );
    _drawLine(
      canvas,
      portrait
          ? Offset(dx + handle.width / 2, dy)
          : Offset(dx, dy + handle.height / 2),
      portrait ? Offset(size.width, dy) : Offset(dx, size.height),
      paint,
    );

    if (!hideHandle) {
      final circlePaint = Paint()
        ..color = handleColor
        ..style = PaintingStyle.fill;
      final rect = Rect.fromCenter(
        center: Offset(dx, dy),
        width: handle.width,
        height: handle.height,
      );

      if (fillHandle) canvas.drawRRect(handleRadius.toRRect(rect), circlePaint);

      final handleOutlinePaint = Paint()
        ..color = handleOutlineColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawRRect(handleRadius.toRRect(rect), handleOutlinePaint);
    }
  }

  /// Draws a straight segment from [start] to [end], honouring [lineStyle].
  ///
  /// Solid styles draw a single line; dashed/dotted styles walk the configured
  /// [DividerLineStyle.pattern], alternating drawn segments and gaps. A
  /// zero-length drawn segment paints a dot (round caps make it circular).
  void _drawLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final pattern = lineStyle.pattern;
    if (pattern.isEmpty) {
      canvas.drawLine(start, end, paint);
      return;
    }

    final delta = end - start;
    final length = delta.distance;
    if (length <= 0) return;
    final direction = delta / length;

    var distance = 0.0;
    var index = 0;
    var draw = true;
    while (distance < length) {
      final segment = pattern[index % pattern.length];
      final reach = distance + segment;
      final next = reach < length ? reach : length;
      if (draw) {
        canvas.drawLine(
          start + direction * distance,
          start + direction * next,
          paint,
        );
      }
      // Guard against zero-length gaps that would never advance the cursor.
      if (!draw && next <= distance) break;
      distance = next;
      draw = !draw;
      index++;
    }
  }

  @override
  bool shouldRepaint(_DividerPainter oldDelegate) => true;
}
