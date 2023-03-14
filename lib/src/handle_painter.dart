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
  final Size handleSize;
  final BorderRadius handleRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final color = strokeWidth <= 0.0000 ? Colors.transparent : this.color;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final dx = portrait ? size.width * handlePosition : size.width * position;
    final dy = portrait ? size.height * position : size.height * handlePosition;
    final handle = hideHandle
        ? Size.zero
        : portrait
            ? Size(handleSize.height, handleSize.width)
            : Size(handleSize.width, handleSize.height);

    canvas
      ..drawLine(
        portrait ? Offset(0, dy) : Offset(dx, 0),
        portrait
            ? Offset(dx - handle.width / 2, dy)
            : Offset(dx, dy - handle.height / 2),
        paint,
      )
      ..drawLine(
        portrait
            ? Offset(dx + handle.width / 2, dy)
            : Offset(dx, dy + handle.height / 2),
        portrait ? Offset(size.width, dy) : Offset(dx, size.height),
        paint,
      );

    if (!hideHandle) {
      final circlePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      final rect = Rect.fromCenter(
        center: Offset(dx, dy),
        width: handle.width,
        height: handle.height,
      );

      if (fillHandle) canvas.drawRRect(handleRadius.toRRect(rect), circlePaint);
      canvas.drawRRect(handleRadius.toRRect(rect), paint);
    }
  }

  @override
  bool shouldRepaint(_HandlePainter oldDelegate) => true;
}
