import 'package:flutter/material.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';

class JobDurationAndStatus extends StatelessWidget {
  final double averageDuration;
  const JobDurationAndStatus({
    super.key,
    required this.averageDuration,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    const double maxDuration = 24.0;
    return RoundedContainer(
        height: screenHeight * 0.25,
        width: screenWidth * 0.90,
        padding: const EdgeInsets.all(Sizes.md),
        radius: Sizes.cardRadiusMd,
        backgroundColor: CustomColors.primary,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Average Job Duration',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white)
            ),
        const SizedBox(height: Sizes.spaceBtwItems),
        Text(
          '${averageDuration.toStringAsFixed(1)} hrs',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white),
        ),
    
          ],
        ),
        
        Column(
          children: [
            LinearProgressIndicator(
              value: (averageDuration / maxDuration).clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: Colors.grey.shade300,
              color: CustomColors.success,
              borderRadius: BorderRadius.circular(8),
            ),
    
        const SizedBox(height: Sizes.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text('0 hrs',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)),
            Text('24 hrs',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)),
          ],
        ),
          ],
        ),
      ],
    ),
      );
  }
}
