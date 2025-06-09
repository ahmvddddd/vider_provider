import 'package:flutter/material.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../images/t_circular_image.dart';
import '../texts/t_brand_title_text_with_verified_icon.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    this.onTap,
    required this.showBorder,
  });

  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunction.isDarkMode(context);
    return GestureDetector(
    onTap: onTap,
    //container image
    child: RoundedContainer(
      showBorder: showBorder,
      padding: const EdgeInsets.all(Sizes.sm),
      backgroundColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Flexible(
            child: CircularImage(
              isNetworkImage: false,
              image: 'Images.darkAppLogo',
              backgroundColor: Colors.transparent,
              overlayColor: isDark ? CustomColors.white : CustomColors.black,
            ),
          ),
          const SizedBox(width: Sizes.spaceBtwItems / 2,),
                    
          //Text
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TBrandTitleTextWithVerifiedIcon(title: 'Nike', brandTextSize: TextSizes.large),
                Text( '256 products available in store',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
          )
      ],
      ),
      ),
                    );
  }
}
