import 'package:flutter/material.dart';
import '../../../../../utils/constants/custom_colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';
import '../../custom_shapes/containers/rounded_container.dart';

class JobCategoryCard extends StatelessWidget {
  const JobCategoryCard({super.key, required this.categoryText});

  final String categoryText;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final dark = HelperFunction.isDarkMode(context);
    return RoundedContainer(
      width: screenWidth * 0.16,
      backgroundColor: dark ? CustomColors.dark : CustomColors.light,
      padding: const EdgeInsets.all(Sizes.xs),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              categoryText,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall,
                  textAlign: TextAlign.center,
                  softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
