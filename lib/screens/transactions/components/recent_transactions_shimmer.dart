import 'package:flutter/material.dart';
import '../../../common/widgets/layouts/listvew.dart';
import '../../../common/widgets/shimmer/shimmer_widget.dart';
import '../../../utils/constants/sizes.dart';

class RecentTransactionsShimmer extends StatelessWidget {
  const RecentTransactionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              width: screenWidth * 0.10,
              height: screenHeight * 0.01,
              radius: 50,
            ),
    
            ShimmerWidget(
              width: screenWidth * 0.08,
              height: screenHeight * 0.01,
              radius: 50,
            ),
          ],
        ),
    
        const SizedBox(height: Sizes.spaceBtwItems),
        HomeListView(
          seperatorBuilder:
              (context, index) => const SizedBox(height: Sizes.spaceBtwItems),
          scrollDirection: Axis.vertical,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ShimmerWidget(
                      width: screenHeight * 0.03,
                      height: screenHeight * 0.03,
                      radius: 100,
                    ),
    
                    const SizedBox(width: Sizes.sm),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(
                              width: screenWidth * 0.25,
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
                      ],
                    ),
                  ],
                ),
    
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerWidget(
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.01,
                      radius: 50,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
