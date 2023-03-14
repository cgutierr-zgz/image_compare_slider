part of 'image_compare_slider.dart';

class _SliderClipper extends CustomClipper<Rect> {
  _SliderClipper({required this.position, required this.direction})
      : invert = false;
  _SliderClipper.inverted({required this.position, required this.direction})
      : invert = true;

  final bool invert;
  final double position;
  final SliderDirection direction;

  @override
  Rect getClip(Size size) {
    switch (direction) {
      case SliderDirection.leftToRight:
        if (invert) {
          final dx = position * size.width;
          return Rect.fromLTRB(0, 0, dx, size.height);
        } else {
          final dx = position * size.width;
          return Rect.fromLTRB(dx, 0, size.width, size.height);
        }
      case SliderDirection.rightToLeft:
        if (invert) {
          final dx = position * size.width;
          return Rect.fromLTRB(dx, 0, size.width, size.height);
        } else {
          final dx = position * size.width;
          return Rect.fromLTRB(0, 0, dx, size.height);
        }
      case SliderDirection.topToBottom:
        if (invert) {
          final dy = position * size.height;
          return Rect.fromLTRB(0, 0, size.width, dy);
        } else {
          final dy = position * size.height;
          return Rect.fromLTRB(0, dy, size.width, size.height);
        }
      case SliderDirection.bottomToTop:
        if (invert) {
          final dy = position * size.height;
          return Rect.fromLTRB(0, dy, size.width, size.height);
        } else {
          final dy = position * size.height;
          return Rect.fromLTRB(0, 0, size.width, dy);
        }
    }
  }

  @override
  bool shouldReclip(_SliderClipper oldClipper) => true;
}
