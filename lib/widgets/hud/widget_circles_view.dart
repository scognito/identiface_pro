import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:face_detector/config/app_colors.dart';
import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/widgets/hud/widget_circles_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class WidgetCirclesView extends StatelessWidget {
  final int numCircles;

  const WidgetCirclesView({required this.numCircles, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < numCircles; i++)
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleView(),
          ),
      ],
    );
  }
}

class CircleView extends StatelessWidget {
  const CircleView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WidgetCirclesViewModel>.reactive(
      viewModelBuilder: () => WidgetCirclesViewModel(),
      builder: (_, model, child) {
        return DashedCircularProgressBar.aspectRatio(
          aspectRatio: 1,
          progress: model.currentValue.toDouble(),
          maxProgress: 100,
          corners: StrokeCap.butt,
          foregroundColor: AppColors.defaultThemeHudCyan.withOpacity(0.8),
          backgroundColor: AppColors.defaultThemeHudCyanDark.withOpacity(0.5),
          foregroundStrokeWidth: 5,
          backgroundStrokeWidth: 5,
          animation: true,
          child: Center(
            child: Text(
              '${model.currentValue} %',
              style: AppText.font12Regular,
            ),
          ),
        );
      },
    );
  }
}
