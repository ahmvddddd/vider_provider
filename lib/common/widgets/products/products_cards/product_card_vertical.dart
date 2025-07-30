import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/custom_colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';
import '../../../styles/shadows.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../icons/circular_icon.dart';
import '../../images/rounded_image.dart';
import '../../texts/product_title_text.dart';
import '../../texts/t_brand_title_text_with_verified_icon.dart';
import 'product_price_text.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(Sizes.productImageRadius),
          color: dark ? CustomColors.darkerGrey : CustomColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Thumbnail, wishlist button, discount tag
            RoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(Sizes.sm),
              backgroundColor: dark ? CustomColors.dark : CustomColors.light,

              child: Stack(
                children: [
                  //Thumbnail Image
                  RoundedImage(
                    imageUrl: 'Images.productImage1',
                    applyImageRadius: true,
                  ),

                  //sale tag
                  Positioned(
                    top: 12,
                    child: RoundedContainer(
                      radius: Sizes.sm,
                      backgroundColor: CustomColors.secondary.withValues(
                        alpha: 0.8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.sm,
                        vertical: Sizes.xs,
                      ),
                      child: Text(
                        '25%',
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: CustomColors.black,
                        ),
                      ),
                    ),
                  ),

                  //Favourite Icon Button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CircularIcon(
                      icon: Iconsax.heart5,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems / 2),

            //Details
            Padding(
              padding: const EdgeInsets.only(left: Sizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title: 'Nice Kicks', smallSize: true),
                  SizedBox(height: Sizes.spaceBtwItems / 2),
                  TBrandTitleTextWithVerifiedIcon(title: 'Nike'),
                ],
              ),
            ),

            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Price
                Padding(
                  padding: const EdgeInsets.only(left: Sizes.sm),
                  child: TProductPriceText(price: '100'),
                ),

                //Add to cart
                Container(
                  decoration: BoxDecoration(
                    color: CustomColors.dark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Sizes.cardRadiusMd),
                      bottomRight: Radius.circular(Sizes.productImageRadius),
                    ),
                  ),
                  child: SizedBox(
                    width: Sizes.iconLg * 1.2,
                    height: Sizes.iconLg * 1.2,
                    child: Center(
                      child: const Icon(Iconsax.add, color: CustomColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
