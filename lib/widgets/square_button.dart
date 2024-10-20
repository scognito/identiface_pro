import 'package:face_detector/config/constants.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/widgets/flat_icon_button.dart';
import 'package:face_detector/widgets/square_material_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SquareButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;
  final double? iconSize;

  const SquareButton({
    super.key,
    required this.asset,
    required this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    String themeName = Provider.of<SettingsProvider>(context).getThemeName();

    switch (themeName) {
      case kThemeDefault:
        return FlatIconButton(
          asset: asset,
          onTap: onTap,
          iconSize: iconSize,
        );
      case kThemeMaterial:
      default:
        return SquareMaterialButton(
          asset: asset,
          onTap: onTap,
          iconSize: iconSize,
        );
    }
  }
}
