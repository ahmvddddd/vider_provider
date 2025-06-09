import 'package:flutter/material.dart';

import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../custom_shapes/containers/rounded_container.dart';
import 'brand_card.dart';

class BrandShowcase extends StatelessWidget {
  const BrandShowcase({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      showBorder: true,
      borderColor: CustomColors.grey,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(Sizes.md),
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwInputFields),
      child: Column(
        children: [
          // Brand with products count
          const BrandCard(showBorder: false),
          const SizedBox(height: Sizes.spaceBtwItems,),

          //Brand Top 3 product Images
          Row(
            children: images.map((image) => brandTopProductImageWidget(image, context)).toList())
      ],
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context) {
    return Expanded(
      child: RoundedContainer(
      height: 100,
      padding: const EdgeInsets.all(Sizes.md),
      margin: const EdgeInsets.only(right: Sizes.sm),
      backgroundColor: HelperFunction.isDarkMode(context) ? CustomColors.darkGrey : CustomColors.light,
      child:  Image(fit: BoxFit.contain, image: AssetImage(image)),
      ),
      );
  }
}

