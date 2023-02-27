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
    final handle = hideHandle
        ? Size.zero
        : portrait
            ? Size(handleSize.height, handleSize.width)
            : Size(handleSize.width, handleSize.height);
    final color = strokeWidth == 0.0000 ? Colors.transparent : this.color;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final dx = portrait ? size.width / 2 : size.width * position;
    final dy = portrait ? size.height * position : size.height / 2;

    if (portrait) {
      canvas
        ..drawLine(
          Offset(size.width, dy),
          Offset(
            handlePosition * size.width + handle.width * size.width / 2,
            dy,
          ),
          paint,
        )
        ..drawLine(
          Offset(0, dy),
          Offset(
            handlePosition * size.width - handle.width * size.width / 2,
            dy,
          ),
          paint,
        );
    } else {
      canvas
        ..drawLine(
          Offset(dx, 0),
          Offset(
            dx,
            handlePosition * size.height - handle.height * size.height / 2,
          ),
          paint,
        )
        ..drawLine(
          Offset(dx, size.height),
          Offset(
            dx,
            handlePosition * size.height + handle.height * size.height / 2,
          ),
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
        width: size.width * handle.width,
        height: size.height * handle.height,
      );

      if (fillHandle) canvas.drawRRect(handleRadius.toRRect(rect), circlePaint);

      canvas.drawRRect(handleRadius.toRRect(rect), borderPaint);
    }
  }

  @override
  bool shouldRepaint(_HandlePainter oldDelegate) => true;
}
