import 'package:face_detector/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SquareMaterialButton extends StatelessWidget {
  final String asset;
  final Function onTap;
  final double? iconSize;

  const SquareMaterialButton({
    super.key,
    required this.asset,
    required this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(const Size(50, 50)),
      child: ElevatedButton(
        onPressed: () => onTap(),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.zero,
        ),
        child: SvgPicture.asset(
          asset,
          height: iconSize ?? 30,
          colorFilter: ColorFilter.mode(ThemeUtils.getIconColor(context), BlendMode.srcIn),
        ),
      ),
    );
  }
}
