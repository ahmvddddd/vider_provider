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
    const double maxDuration = 12.0;
    return Row(
      children: [
        Expanded(
          child: RoundedContainer(
            height: screenHeight * 0.20,
            padding: const EdgeInsets.all(Sizes.xs),
            radius: Sizes.cardRadiusSm,
            backgroundColor: CustomColors.primary,
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Average Job Duration',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white)
            ),
            const SizedBox(height: Sizes.sm),
            Text(
              '${averageDuration.toStringAsFixed(1)} hrs',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white)
            ),

            const SizedBox(height: Sizes.spaceBtwItems),
            LinearProgressIndicator(
              value: (averageDuration / maxDuration).clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: Colors.grey.shade300,
              color: CustomColors.success,
              borderRadius: BorderRadius.circular(8),
            ),

            const SizedBox(height: Sizes.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text('0 hrs',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white, fontSize: 10)),
                Text('12 hrs',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white, fontSize: 10)),
              ],
            ),
          ],
        ),
          ),
        ),

        //chart
        const SizedBox(width: Sizes.sm),
        Expanded(
          child: RoundedContainer(
            height: screenHeight * 0.20,
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
