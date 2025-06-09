import 'package:flutter/material.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/helpers/helper_function.dart';

class CoverImage extends StatelessWidget {
  final String coverImageString;
  final String profileImage;
  const CoverImage({
    super.key,
    required this.profileImage,
    required this.coverImageString,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mxCardHeight = screenHeight * 0.40;
    double horizontalCardHeight = screenHeight * 0.20;
    final dark = HelperFunction.isDarkMode(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: mxCardHeight * 0.90,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(coverImageString),
              fit: BoxFit.cover,
              opacity: 0.8,
            ),
          ),
        ),

        //Icon
        Positioned(
          left: 0,
          right: 0,
          bottom: -30,
          width: horizontalCardHeight * 0.95,
          height: horizontalCardHeight * 0.95,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: CustomColors.primary, width: 2),
              shape: BoxShape.circle,
              color: dark ? Colors.black : Colors.white,
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  profileImage,
                  fit: BoxFit.cover,
                  height: horizontalCardHeight * 0.85,
                  width: horizontalCardHeight * 0.85,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
