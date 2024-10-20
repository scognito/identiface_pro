import 'dart:async';
import 'dart:math';

import 'package:face_detector/config/app_colors.dart';
import 'package:flutter/material.dart';

class WidgetHudProgressbar extends StatefulWidget {
  const WidgetHudProgressbar({super.key});

  @override
  WidgetHudProgressbarState createState() => WidgetHudProgressbarState();
}

class WidgetHudProgressbarState extends State<WidgetHudProgressbar>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  final Random _random = Random();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRandomProgress();
  }

  void _startRandomProgress() {
    _timer = Timer.periodic(Duration(seconds: _random.nextInt(5) + 1), (timer) {
      setState(() {
        _progress = _random.nextDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SegmentedProgressBarPainter(_progress),
      child: const SizedBox(width: 200, height: 40),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class SegmentedProgressBarPainter extends CustomPainter {
  final double progress;

  const SegmentedProgressBarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.defaultThemeHudCyan
      ..strokeWidth = size.height
      ..style = PaintingStyle.stroke;

    int segments = 20; // Number of segments
    double segmentWidth = size.width / segments;
    double gapWidth = segmentWidth / 4; // Adjust the gap size

    for (int i = 0; i < segments; i++) {
      if (i < (segments * progress).floor()) {
        double startX = i * segmentWidth + gapWidth / 2;
        double endX = startX + segmentWidth - gapWidth;
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(endX, size.height / 2),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
