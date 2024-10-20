import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const AppScaffold({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    debugPrint('Size: width: ${mq.width}, height: ${mq.height}');
    debugPrint('Shortest size: ${mq.shortestSide}');

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: child,
    );
  }
}
