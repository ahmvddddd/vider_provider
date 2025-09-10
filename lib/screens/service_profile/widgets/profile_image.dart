import 'package:flutter/material.dart';
import '../../../common/widgets/image/full_screen_image_view.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class ProfileImage extends StatelessWidget {
  final String imageAvatar;
  final String fullname;
  final Color ratingColor;
  final double rating;
  final String service;
  final double hourlyRate;

  const ProfileImage({
    super.key,
    required this.imageAvatar,
    required this.fullname,
    required this.ratingColor,
    required this.rating,
    required this.service,
    required this.hourlyRate,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => FullScreenImageView(
                      images: [imageAvatar], // Pass all images
                      initialIndex: 0, // Start from tapped image
                    ),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              // image: DecorationImage(image: NetworkImage(imageAvatar),
              // fit: BoxFit.contain,
              // ),
              border: Border.all(
                color: dark ? CustomColors.darkGrey : CustomColors.darkGrey,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  imageAvatar,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.height * 0.15,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: Sizes.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fullname,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: dark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: Sizes.sm),
            Row(
              children: [
                Icon(Icons.star, color: ratingColor, size: Sizes.iconMd),
                Text(
                  rating.toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: dark ? Colors.white : Colors.black,
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          service,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: dark ? CustomColors.darkGrey : CustomColors.darkerGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\$$hourlyRate/hr',
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: CustomColors.success,
            fontFamily: 'JosefinSans',
          ),
        ),

        const SizedBox(height: Sizes.sm),
      ],
    );
  }
}
