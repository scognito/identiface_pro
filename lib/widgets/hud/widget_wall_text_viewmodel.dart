import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class WidgetWallTextViewModel extends BaseViewModel {
  final List<int> _numbers = [];
  final Random _random = Random();
  late AnimationController _animationController;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();

  List<int> get numbers => _numbers;

  ScrollController get scrollController => _scrollController;

  Animation<double> get animation => _animation;

  WidgetWallTextViewModel({required TickerProvider tickerProvider}) {
    _populateInitialData();
    _initializeAnimation(tickerProvider);
  }

  void _populateInitialData() {
    for (int i = 0; i < 200; i++) {
      _numbers.add(_random.nextInt(1000));
    }
    notifyListeners();
  }

  void reset() {
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    notifyListeners();
  }

  void _initializeAnimation(TickerProvider tickerProvider) {
    _animationController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: tickerProvider,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent * _animation.value);
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
