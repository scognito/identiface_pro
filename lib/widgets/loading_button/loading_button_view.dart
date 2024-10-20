import 'package:face_detector/utils/theme_utils.dart';
import 'package:face_detector/widgets/loading_button/loading_button_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoadingButtonView extends StatelessWidget {
  final String label;
  final bool isDangerous;
  final Function onPressed;

  const LoadingButtonView({
    required this.label,
    required this.onPressed,
    this.isDangerous = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoadingButtonViewmodel>.reactive(
      viewModelBuilder: () => LoadingButtonViewmodel(onPressed: onPressed),
      builder: (builderContext, model, child) {
        return ElevatedButton(
          onPressed: () => model.isBusy ? null : model.onTap(),
          style: isDangerous
              ? ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 2),
                  shadowColor: Colors.transparent,
                )
              : null,
          child: model.isBusy
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ThemeUtils.getIconColor(context),
                    ),
                  ),
                )
              : Text(
                  label,
                  style: isDangerous
                      ? const TextStyle(fontWeight: FontWeight.bold).copyWith(color: Colors.red)
                      : null,
                ),
        );
      },
    );
  }
}
