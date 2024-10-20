import 'package:face_detector/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlatIconButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;
  final double? iconSize;

  const FlatIconButton({
    super.key,
    required this.asset,
    required this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SvgPicture.asset(
        asset,
        height: iconSize ?? 30,
        colorFilter: ColorFilter.mode(ThemeUtils.getIconColor(context), BlendMode.srcIn),
      ),
    );
  }
}
