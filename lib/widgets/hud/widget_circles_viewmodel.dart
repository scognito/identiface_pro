import 'dart:async';
import 'dart:math';

import 'package:stacked/stacked.dart';

class WidgetCirclesViewModel extends BaseViewModel {
  Timer? timer;
  int _currentValue = 0;

  int get currentValue => _currentValue;

  final Random _random = Random();

  WidgetCirclesViewModel() {
    init();
  }

  void init() {
    _currentValue = _random.nextInt(50) + 50;

    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _currentValue++;
      if (_currentValue >= 100) {
        _currentValue = _random.nextInt(50) + 50;
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
