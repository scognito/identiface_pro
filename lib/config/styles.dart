import 'package:flutter/material.dart';

class Styles {
  static ButtonStyle cyberpunkButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return Colors.transparent;
        },
      ),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.cyanAccent),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.cyanAccent, width: 2),
        ),
      ),
      elevation: WidgetStateProperty.all(5.0),
      shadowColor: WidgetStateProperty.all<Color>(Colors.greenAccent),
    );
  }

  static InputDecorationTheme cyberpunkTextFieldDecorationTheme() {
    return const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.black12, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.black12, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      filled: true,
      fillColor: Colors.black12,
      hintStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: Colors.white),
    );
  }
}

class SquareThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const SquareThumbShape({this.thumbRadius = 10.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: thumbRadius * 2,
      height: thumbRadius * 2,
    );

    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.cyanAccent
      ..style = PaintingStyle.fill;

    canvas.drawRect(thumbRect, paint);
  }
}
