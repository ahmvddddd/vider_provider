import 'package:flutter/material.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class CertificationTitle extends StatelessWidget {
  final String title;
  const CertificationTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth= MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.35;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.055,
          width: cardWidth * 0.95,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
              color: dark
                ? CustomColors.white.withValues(alpha: 0.1)
                : CustomColors.black.withValues(alpha: 0.1),),
          padding: const EdgeInsets.all(2),
          child: Center(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!.copyWith(color: dark
               ? CustomColors.white
               : CustomColors.black)
            ),
          ),
        ),
      ],
    );
  }
}
