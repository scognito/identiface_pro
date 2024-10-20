import 'package:face_detector/config/app_colors.dart';
import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/widgets/custom_painters/custom_painter_hud_box.dart';
import 'package:face_detector/widgets/hud/widget_wall_text_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

class WidgetWallTextView extends StatelessWidget {
  const WidgetWallTextView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WidgetWallTextViewModel>.reactive(
      viewModelBuilder: () => WidgetWallTextViewModel(tickerProvider: const TickerProviderVSync()),
      builder: (builderContext, model, child) {
        return CustomPaint(
          painter: const CustomPainterHudBox(corner: Corner.bottomLeft, cutLength: 10),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  model.reset();
                }
                return true;
              },
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(builderContext).copyWith(scrollbars: false),
                child: ListView.builder(
                  controller: model.scrollController,
                  itemCount: model.numbers.length,
                  itemBuilder: (_, index) {
                    return Container(
                      color:
                          index % 10 == 0 ? AppColors.defaultThemeHudCyanDark : Colors.transparent,
                      child: Text(
                        'POSITION • ${model.numbers[index].toRadixString(16).padLeft(4, '0')} ${model.numbers[index].toRadixString(2).padLeft(5, '0')}',
                        style: AppText.font8Regular.copyWith(color: AppColors.defaultThemeHudCyan),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TickerProviderVSync implements TickerProvider {
  const TickerProviderVSync();

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
