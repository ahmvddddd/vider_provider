import 'package:flutter/material.dart';

import '../../../common/widgets/custom_shapes/divider/custom_divider.dart';
import '../../../common/widgets/layouts/listvew.dart';
import '../../../common/widgets/shimmer/shimmer_widget.dart';
import '../../../utils/constants/sizes.dart';

class ServiceProfileShimmer extends StatelessWidget {
  const ServiceProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //background image
                ShimmerWidget(
                  width: screenWidth * 0.90,
                  height: screenHeight * 0.30,
                  radius: Sizes.cardRadiusMd,
                ),
      
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Sizes.spaceBtwSections),
                    //userinfo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(
                              width: screenWidth * 0.40,
                              height: screenHeight * 0.01,
                              radius: 50,
                            ),
                            const SizedBox(height: Sizes.xs),
                            //service rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //service and location
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //service
                                    ShimmerWidget(
                                      width: screenWidth * 0.10,
                                      height: screenHeight * 0.01,
                                      radius: 50,
                                    ),
                                    const SizedBox(height: Sizes.xs),
                                    ShimmerWidget(
                                      width: screenWidth * 0.10,
                                      height: screenHeight * 0.01,
                                      radius: 50,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
      
                const CustomDivider(
            padding:  EdgeInsets.all(Sizes.spaceBtwItems)
            ),
      
                //images
                HomeListView(
                  sizedBoxHeight: screenHeight * 0.05,
                  scrollDirection: Axis.horizontal,
                  seperatorBuilder: (context, index) {
                    return const SizedBox(width: Sizes.sm);
                  },
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                      ),
                      child: ShimmerWidget(
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.08,
                        radius: Sizes.cardRadiusMd,
                      ),
                    );
                  },
                ),
      
                const CustomDivider(
            padding:  EdgeInsets.all(Sizes.spaceBtwItems)
            ),
      
                HomeListView(
                  sizedBoxHeight: screenHeight * 0.05,
                  scrollDirection: Axis.horizontal,
                  seperatorBuilder: (context, index) {
                    return const SizedBox(width: Sizes.sm);
                  },
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return ShimmerWidget(
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.05,
                      radius: 50,
                    );
                  },
                ),
      
                const CustomDivider(
            padding:  EdgeInsets.all(Sizes.spaceBtwItems)
            ),
      
                ShimmerWidget(
                  width: screenWidth * 0.90,
                  height: screenHeight * 0.02,
                  radius: 50,
                ),
                const SizedBox(height: Sizes.xs),
                ShimmerWidget(
                  width: screenWidth * 0.90,
                  height: screenHeight * 0.02,
                  radius: 50,
                ),
                const SizedBox(height: Sizes.xs),
                ShimmerWidget(
                  width: screenWidth * 0.70,
                  height: screenHeight * 0.02,
                  radius: 50,
                ),
      
                const CustomDivider(
            padding:  EdgeInsets.all(Sizes.spaceBtwItems)
            ),
                //certifications
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerWidget(
                      width: screenWidth * 0.10,
                      height: screenHeight * 0.02,
                      radius: 50,
                    ),
                  ],
                ),
      
                ShimmerWidget(
                  width: screenWidth * 0.90,
                  height: screenHeight * 0.02,
                  radius: 50,
                ),
                const SizedBox(height: Sizes.xs),
                ShimmerWidget(
                  width: screenWidth * 0.90,
                  height: screenHeight * 0.02,
                  radius: 50,
                ),
                const SizedBox(height: Sizes.xs),
                ShimmerWidget(
                  width: screenWidth * 0.70,
                  height: screenHeight * 0.02,
                  radius: 50,
                ),
      
                const CustomDivider(
            padding:  EdgeInsets.all(Sizes.spaceBtwItems)
            ),
      
                ShimmerWidget(
                  width: screenWidth * 0.90,
                  height: screenHeight * 0.02,
                  radius: 50,
                ),
                const SizedBox(height: Sizes.xs),
                ShimmerWidget(
                  width: screenWidth * 0.90,
                  height: screenHeight * 0.02,
                  radius: 50,
                ),
                const SizedBox(height: Sizes.xs),
                ShimmerWidget(
                  width: screenWidth * 0.70,
                  height: screenHeight * 0.02,
                  radius: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
