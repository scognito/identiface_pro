import 'package:face_detector/config/app_colors.dart';
import 'package:face_detector/config/assets.dart';
import 'package:face_detector/widgets/hud/widget_mixer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class WidgetMixerView extends StatelessWidget {
  final double barWidth;
  final int numBars;
  final int barSegments;

  const WidgetMixerView({
    required this.barWidth,
    required this.numBars,
    required this.barSegments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < numBars; i++)
          Padding(
            padding: EdgeInsets.only(right: i == numBars - 1 ? 0 : 4.0),
            child: WidgetMixerColumnView(
              barSegments: barSegments,
              barWidth: barWidth,
            ),
          ),
      ],
    );
  }
}

class WidgetMixerColumnView extends StatelessWidget {
  final int barSegments;
  final double barWidth;

  const WidgetMixerColumnView({
    required this.barSegments,
    required this.barWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WidgetMixerViewModel>.reactive(
      viewModelBuilder: () => WidgetMixerViewModel(barSegmentsLength: barSegments),
      builder: (builderContext, model, child) {
        return Row(
          children: [
            Column(
              children: [
                Image.asset(
                  Assets.imageMixerBarUp,
                  width: barWidth * 1.5,
                  semanticLabel: 'bar',
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.defaultThemeHudCyanDark,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      verticalDirection: VerticalDirection.up,
                      children: [
                        for (int i = 0; i < model.barSegmentsLength; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: i == 0 ? 0 : barWidth / 10,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              color: model.segments[i].isOn
                                  ? AppColors.defaultThemeHudCyan
                                  : AppColors.defaultThemeHudCyanDark,
                              width: barWidth,
                              height: barWidth / 4,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  Assets.imageMixerBarDown,
                  width: barWidth * 1.5,
                  semanticLabel: 'bar',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class WidgetMixerRowView extends StatelessWidget {
  final int barSegments;
  final double barWidth;

  const WidgetMixerRowView({
    required this.barSegments,
    required this.barWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WidgetMixerViewModel>.reactive(
      viewModelBuilder: () => WidgetMixerViewModel(barSegmentsLength: barSegments),
      builder: (builderContext, model, child) {
        return Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.defaultThemeHudCyanDark,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      verticalDirection: VerticalDirection.up,
                      children: [
                        for (int i = 0; i < model.barSegmentsLength; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              left: i == 0 ? 0 : barWidth / 10,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              color: model.segments[i].isOn
                                  ? AppColors.defaultThemeHudCyan
                                  : AppColors.defaultThemeHudCyanDark,
                              width: barWidth / 4,
                              height: barWidth,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
