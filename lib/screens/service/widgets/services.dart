import 'package:flutter/material.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class Services extends StatelessWidget {
  final String service;
  const Services({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: dark 
          ? CustomColors.white
          :CustomColors.black,
        ),
          borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
          color: dark 
          ? Colors.white.withValues(alpha: 0.1)
          :Colors.black.withValues(alpha: 0.1)),
      padding: const EdgeInsets.all(2),
      child: Center(
        child: Text(
          service,
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color:dark
               ? CustomColors.white
               : CustomColors.black),
        ),
      ),
    );
  }
}
