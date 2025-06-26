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
        border: Border.all(color: CustomColors.primary,
        width: 0.5),
          borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
          color: dark ? Colors.black : Colors.white),
      padding: const EdgeInsets.symmetric(vertical: Sizes.xs, horizontal: Sizes.xs + 1),
      child: Center(
        child: Text(
          service,
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color:dark ?Colors.white : Colors.black),
        ),
      ),
    );
  }
}
