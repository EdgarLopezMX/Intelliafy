import 'package:flutter/material.dart';

class HeaderCurvedContainer extends CustomPainter {
  final Color color;
  HeaderCurvedContainer({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path()
      ..lineTo(0, size.height * 0.75) // Baja hasta el 75% del contenedor
      ..quadraticBezierTo(
          size.width * 0.15,
          size.height, // Punto de control (curva hacia abajo)
          size.width * 0.5,
          size.height * 0.85) // Punto medio
      ..quadraticBezierTo(
          size.width * 0.85,
          size.height * 0.70, // Punto de control (curva hacia arriba)
          size.width,
          size.height * 0.9) // Final a la derecha
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
