import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/custom_colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';
import '../../custom_shapes/containers/rounded_container.dart';

class ProfileCard extends StatelessWidget {
  final String serviceImage;
  final String profileImage;
  final String profileName;
  final String service;
  final Color iconColor;
  const ProfileCard({
    super.key,
    required this.profileImage,
    required this.profileName,
    required this.service,
    this.iconColor = Colors.blue,
    required this.serviceImage,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final dark = HelperFunction.isDarkMode(context);
    return GestureDetector(
      onTap: () {},
      child: RoundedContainer(
          width: screenWidth * 0.65,
          padding: const EdgeInsets.all(Sizes.xs),
          radius: Sizes.cardRadiusLg,
          backgroundColor: dark ? CustomColors.dark : CustomColors.light,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //serviceImage
              ClipRRect(
                borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
                child: Container(
                  width: screenWidth * 0.65,
                  height: screenHeight * 0.30,
                  decoration: BoxDecoration(
                    color: dark ? CustomColors.black : CustomColors.white,
                    borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
                  ),
                  child: Image.asset(
                    serviceImage,
                    height: screenHeight * 0.35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //profileImage, name and rating
              const SizedBox(height: Sizes.xs),
              Padding(
                padding: const EdgeInsets.all(Sizes.xs),
                child: Row(
                  children: [
                    Container(
                      height: screenHeight * 0.04,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dark ? CustomColors.black : CustomColors.white,
                      ),
                      child: Image.asset(profileImage,
                          height: screenHeight * 0.035, fit: BoxFit.cover),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      profileName,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Icon(
                      Iconsax.verify,
                      color: iconColor,
                      size: Sizes.iconSm,
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.xs, vertical: Sizes.sm),
                child: Container(
                  height: screenHeight * 0.04,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Sizes.borderRadiusMd),
                      color: CustomColors.primary),
                  padding: const EdgeInsets.all(Sizes.sm),
                  child: Center(
                    child: Text(
                      service,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
