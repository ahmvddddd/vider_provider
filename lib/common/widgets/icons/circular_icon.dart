import 'package:flutter/material.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    super.key, this.width,
    this.height,
    this.size = Sizes.lg,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor != null
        ? backgroundColor!
        : HelperFunction.isDarkMode(context)
        ? CustomColors.black.withValues(alpha: 0.9)
        : CustomColors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(100),
        ),
      
      child: IconButton(onPressed: onPressed, icon: Icon(icon, color: color, size: size),),

    );
  }
}