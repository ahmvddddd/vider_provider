import 'package:flutter/material.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/layouts/listvew.dart';
import '../../../common/widgets/shimmer/shimmer_widget.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class JobsDashBoardShimmer extends StatelessWidget {
  const JobsDashBoardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final dark = HelperFunction.isDarkMode(context);
    return Column(
      children: [
        //total earnings
        RoundedContainer(
          width: screenWidth * 0.90,
          height: screenHeight * 0.12,
          backgroundColor:
              dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                width: screenWidth * 0.30,
                height: screenHeight * 0.01,
                radius: 50,
              ),
              const SizedBox(height: Sizes.xs),
              ShimmerWidget(
                width: screenWidth * 0.50,
                height: screenHeight * 0.01,
                radius: 50,
              ),
            ],
          ),
        ),

        //avg duration and chart
        const SizedBox(height: Sizes.spaceBtwItems),
        RoundedContainer(
          width: screenWidth * 0.90,
          height: screenHeight * 0.15,
          backgroundColor:
              dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                width: screenWidth * 0.30,
                height: screenHeight * 0.01,
                radius: 50,
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              ShimmerWidget(
                width: screenWidth * 0.20,
                height: screenHeight * 0.08,
                radius: Sizes.cardRadiusSm,
              ),
            ],
          ),
        ),

        //heatmap
        const SizedBox(height: Sizes.spaceBtwItems),
        ShimmerWidget(
            width: screenWidth * 0.90,
            height: screenHeight * 0.20,
            radius: Sizes.cardRadiusSm,
        ),

        //Clients      
        const SizedBox(height: Sizes.spaceBtwItems),
        HomeListView(
          sizedBoxHeight: screenHeight * 0.23,
          scrollDirection: Axis.horizontal,
          seperatorBuilder: (context, index) => const SizedBox(width: Sizes.sm),
          itemCount: 4,
          itemBuilder: (context, index) {
            return RoundedContainer(
              height: screenHeight * 0.20,
              width: screenWidth * 0.28,
              radius: Sizes.cardRadiusSm,
              backgroundColor:
                  dark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerWidget(
                    width: screenHeight * 0.05,
                    height: screenHeight * 0.05,
                    radius: 100,
                  ),
                  const SizedBox(height: Sizes.sm),
                  ShimmerWidget(
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.01,
                    radius: 50,
                  ),
                  const SizedBox(height: Sizes.sm),
                  ShimmerWidget(
                    width: screenHeight * 0.03,
                    height: screenHeight * 0.03,
                    radius: 100,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
