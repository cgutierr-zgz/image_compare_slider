part of 'image_compare_slider.dart';

class _HandlePainter extends CustomPainter {
  const _HandlePainter({
    required this.position,
    required this.color,
    required this.strokeWidth,
    required this.portrait,
    required this.hideHandle,
    required this.handlePosition,
    required this.fillHandle,
    required this.handleSize,
    required this.handleRadius,
  });

  final double position;
  final Color color;
  final double strokeWidth;
  final bool portrait;
  final bool hideHandle;
  final bool fillHandle;
  final double handlePosition;
  final double handleSize;
  final BorderRadius handleRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final handle = hideHandle ? 0.0 : handleSize;
    final color = strokeWidth == 0.0 ? Colors.transparent : this.color;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final dx = portrait ? size.width / 2 : size.width * position;

    final dy = portrait ? size.height * position : size.height / 2;

    var shouldPaint = true;
    if (portrait) {
      shouldPaint = handlePosition * size.height > handle / 2;
    } else {
      shouldPaint = handlePosition * size.width > handle / 2;
    }

    if (shouldPaint) {
      canvas.drawLine(
        portrait ? Offset(0, dy) : Offset(dx, 0),
        portrait
            ? Offset(size.width * handlePosition - handle / 2, dy)
            : Offset(dx, size.height * handlePosition - handle / 2),
        paint,
      );
    }

    if (!hideHandle) {
      final borderPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      final circlePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      final center = Offset(
        portrait ? handlePosition * size.width : position * size.width,
        portrait ? position * size.height : handlePosition * size.height,
      );

      final rect = Rect.fromCenter(
        center: center,
        width: handle,
        height: handle,
      );

      if (fillHandle) canvas.drawRRect(handleRadius.toRRect(rect), circlePaint);

      canvas.drawRRect(handleRadius.toRRect(rect), borderPaint);
    }

    if (portrait) {
      shouldPaint = (1 - handlePosition) * size.height > handle / 2;
    } else {
      shouldPaint = (1 - handlePosition) * size.width > handle / 2;
    }

    if (shouldPaint) {
      canvas.drawLine(
        portrait
            ? Offset(size.width * handlePosition + handle / 2, dy)
            : Offset(dx, size.height * handlePosition + handle / 2),
        portrait ? Offset(size.width, dy) : Offset(dx, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_HandlePainter oldDelegate) => true;
}
