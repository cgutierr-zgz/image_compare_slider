part of 'image_compare_slider.dart';

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
  bool shouldReclip(_SliderClipper oldClipper) => true;
}
