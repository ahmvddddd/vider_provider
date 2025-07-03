import 'package:flutter/material.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../settings/settings_screen.dart';

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

        Positioned(
          top: 40,
          right: 15,
          child: GestureDetector(
            onTap: () {
              HelperFunction.navigateScreen(
                              context,
                              SettingsScreen(),
                            );
            },
            child: RoundedContainer(
              backgroundColor: CustomColors.primary,
              padding: const EdgeInsets.all(Sizes.sm),
              radius: 100,
              child: Icon(Icons.settings, color: Colors.white,),
            ),
          )
          ),

        //Icon
        Positioned(
          bottom: -30,
  left: (MediaQuery.of(context).size.width - horizontalCardHeight * 0.95) / 2,
          child: Container(
          width: horizontalCardHeight * 0.95,
          height: horizontalCardHeight * 0.95,
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
