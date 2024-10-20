import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ScanlinePainter extends CustomPainter {
  const ScanlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.3);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final scanlinePaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 5) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CachedScanlinePainter extends CustomPainter {
  final ui.Image scanlineImage;

  const CachedScanlinePainter(this.scanlineImage);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(scanlineImage, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(CachedScanlinePainter oldDelegate) {
    return false;
  }
}
