import 'package:intelliafy_app/exports.dart';

class HeaderCurvedContainer extends CustomPainter {
  final Color color;
  HeaderCurvedContainer({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        Color.alphaBlend(Colors.black.withValues(alpha: 0.1), color),
      ],
    );

    Paint paint = Paint()..shader = gradient.createShader(rect);

    Path path = Path()
      ..lineTo(0, size.height * 0.75)
      ..quadraticBezierTo(
          size.width * 0.15, size.height, size.width * 0.5, size.height * 0.85)
      ..quadraticBezierTo(
          size.width * 0.85, size.height * 0.70, size.width, size.height * 0.9)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawShadow(path.shift(const Offset(0, 2)), Colors.black, 8.0, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
