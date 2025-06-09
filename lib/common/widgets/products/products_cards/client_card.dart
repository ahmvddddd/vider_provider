import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/custom_colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';
import '../../custom_shapes/containers/rounded_container.dart';

class ClientCard extends StatelessWidget {
  final String profileImage;
  final String profileName;
  final int jobsLength;
  final VoidCallback onTap;
  const ClientCard({
    super.key,
    required this.profileImage,
    required this.profileName,
    required this.jobsLength,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalCardHeight = screenHeight * 0.20;
    double cardHeight = screenHeight * 0.28;
    double cardWidth = screenWidth * 0.35;
    final dark = HelperFunction.isDarkMode(context);
    return GestureDetector(
              onTap: onTap,
      child: RoundedContainer(
        height: cardHeight * 0.80,
        width: cardWidth,
        padding: const EdgeInsets.all(Sizes.sm),
        backgroundColor:
            dark
                ? CustomColors.white.withValues(alpha: 0.1)
                : CustomColors.black.withValues(alpha: 0.1),
        showBorder: true,
        borderColor: CustomColors.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: horizontalCardHeight * 0.4,
                    height: horizontalCardHeight * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    color: dark ? Colors.black : Colors.white,),
                    child: Center(
                      child: Image.network(
                        profileImage,
                        fit: BoxFit.cover,
                        height: horizontalCardHeight * 0.4,
                      ),
                    ),
                  ),
                ),
      
                //name
                const SizedBox(height: Sizes.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profileName,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Iconsax.verify,
                      color: Colors.amber,
                      size: Sizes.iconSm,
                    ),
                  ],
                ),
              ],
            ),
      
            //no of jobs
            const SizedBox(height: Sizes.sm),
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle
              ),
              padding: const EdgeInsets.all(Sizes.sm),
              child: Text(
                '$jobsLength',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
              ),
            ),
      
            
          ],
        ),
      ),
    );
  }
}
