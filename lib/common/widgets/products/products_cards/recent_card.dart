import 'package:flutter/material.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';

class RecentCard extends StatelessWidget {
  final IconData transactionIcon;
  final Color iconColor;
  final String transactionType;
  final String description;
  final String amount;
  const RecentCard({
    super.key,
    required this.iconColor,
    required this.transactionIcon,
    required this.transactionType,
    required this.description,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final dark = HelperFunction.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //image
            Container(
              height: screenHeight * 0.05,
              width: screenHeight * 0.05,
              padding: const EdgeInsets.all(Sizes.xs),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(
                  transactionIcon,
                  size: Sizes.iconMd,
                  color: iconColor,
                ),
              ),
            ),
            //name and service
            const SizedBox(width: Sizes.sm),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactionType,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: Sizes.xs),
                    SizedBox(
                      width: screenWidth * 0.50,
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
    
        //amount and duration
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$$amount',
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontFamily: 'JosefinSans', color: iconColor),
            ),
          ],
        ),
      ],
    );
  }
}
