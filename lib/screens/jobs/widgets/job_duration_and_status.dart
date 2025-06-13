import 'package:flutter/material.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class JobDurationAndStatus extends StatelessWidget {
  final double averageDuration;
  final Widget chart;
  const JobDurationAndStatus({
    super.key,
    required this.averageDuration,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    double screenHeight = MediaQuery.of(context).size.height;
    // const double maxDuration = 12.0;
    return Row(
      children: [
        Expanded(
          child: RoundedContainer(
            height: screenHeight * 0.30,
            padding: const EdgeInsets.all(Sizes.xs),
            radius: Sizes.cardRadiusSm,
            backgroundColor: CustomColors.primary,
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Average Job Duration',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white)
            ),
            const SizedBox(height: Sizes.sm),
            Container(
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2
                )
              ),
              child: Center(
                child: Text(
                  '${averageDuration.toStringAsFixed(1)} hrs',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white)
                ),
              ),
            ),
          ],
        ),
          ),
        ),

        //chart
        const SizedBox(width: Sizes.sm),
        Expanded(
          child: RoundedContainer(
            height: screenHeight * 0.30,
            padding: const EdgeInsets.all(Sizes.xs),
            radius: Sizes.cardRadiusSm,
            backgroundColor:
                dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
            child: chart,
          ),
        ),
      ],
    );
  }
}
