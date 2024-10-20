import 'dart:math';

import 'package:stacked/stacked.dart';

class WidgetMixerViewModel extends BaseViewModel {
  final int barSegmentsLength;
  late int targetBarIndex;
  List<BarElement> segments = [];

  Random random = Random();

  WidgetMixerViewModel({required this.barSegmentsLength}) {
    loop();
  }

  Future<void> loop() async {
    while (true) {
      reset();
      await startAnimation();
    }
  }

  void reset() {
    segments.clear();
    targetBarIndex = random.nextInt(barSegmentsLength);

    for (int i = 0; i < barSegmentsLength; i++) {
      segments.add(BarElement(isOn: false));
    }

    notifyListeners();
  }

  Future<void> startAnimation() async {
    int delay = random.nextInt((4) * 100) + 100;
    for (int i = 0; i < barSegmentsLength; i++) {
      if (i < targetBarIndex) {
        segments[i].isOn = true;
        await Future.delayed(Duration(milliseconds: delay));
        notifyListeners();
      } else if (i == targetBarIndex) {
        for (int z = i; z >= 0; z--) {
          segments[z].isOn = false;
          await Future.delayed(const Duration(milliseconds: 20));
          notifyListeners();
        }
        break;
      }
    }
  }
}

class BarElement {
  bool isOn;

  BarElement({required this.isOn});
}
