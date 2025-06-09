import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/custom_shapes/divider/custom_divider.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class NotificationCard extends StatelessWidget {
  final Color borderColor;
  final VoidCallback onTap;
  final Color iconColor;
  final String title;
  final String message;
  final DateTime date;
  const NotificationCard({
    super.key,
    required this.borderColor,
    required this.onTap,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.date
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        width: screenWidth * 0.90,
        borderColor: borderColor,
        backgroundColor:
            dark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(Sizes.sm),
        radius: Sizes.cardRadiusSm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
            Icon(Icons.notifications, color: iconColor),
      
            const SizedBox(width: Sizes.xs),
                SizedBox(
              width: screenWidth * 0.90,
              child: Text(title, style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
                softWrap: true,
                maxLines: 3,)),
              ],
            ),
            const CustomDivider(padding: EdgeInsets.all(Sizes.sm)),
            SizedBox(
              width: screenWidth * 0.70,
              child: Text(
                message,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
                softWrap: true,
                maxLines: 3,
              ),
            ),
              
            const SizedBox(height: Sizes.sm,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
              DateFormat('dd/MM/yy HH:mm:ss').format(date),
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
