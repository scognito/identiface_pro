import 'package:face_detector/config/app_colors.dart';
import 'package:flutter/material.dart';

class CustomPainterHudBox extends CustomPainter {
  final double cutLength;
  final Corner corner;

  const CustomPainterHudBox({required this.cutLength, required this.corner});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.defaultThemeHudCyan
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    switch (corner) {
      case Corner.topLeft:
        path.moveTo(0, cutLength);
        path.lineTo(cutLength, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.close();
        break;
      case Corner.topRight:
        path.moveTo(0, 0);
        path.lineTo(size.width - cutLength, 0);
        path.lineTo(size.width, cutLength);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.close();
        break;
      case Corner.bottomLeft:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(cutLength, size.height);
        path.lineTo(0, size.height - cutLength);
        path.close();
        break;
      case Corner.bottomRight:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height - cutLength);
        path.lineTo(size.width - cutLength, size.height);
        path.lineTo(0, size.height);
        path.close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

enum Corner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
