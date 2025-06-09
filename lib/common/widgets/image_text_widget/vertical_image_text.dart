
import 'package:flutter/material.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    super.key, 
    required this.image, 
    required this.title, 
    this.textColor = CustomColors.white, 
    this.backgroundColor, 
    this.onTap,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: Sizes.spaceBtwItems),
        child: Column(
          children: [
            //Circular icon
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(Sizes.sm),
              decoration: BoxDecoration(
                color: backgroundColor ?? (HelperFunction.isDarkMode(context) ? CustomColors.black : CustomColors.white),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image(image: AssetImage(image), fit: BoxFit.cover, color: dark ? CustomColors.light : CustomColors.dark),
              ),
            ),
      
            //Text
            const SizedBox(height: Sizes.spaceBtwItems / 2,),
            SizedBox(
              width: 55,
              child: Text(title, style: Theme.of(context).textTheme.labelMedium!.apply(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis
              ))
          ],
        ),
      ),
    );
  }
}

