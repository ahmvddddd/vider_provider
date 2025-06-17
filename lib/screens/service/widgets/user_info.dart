import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import 'package:intl/intl.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../settings/settings_screen.dart';

class UserInfo extends StatelessWidget {
  final String fullname;
  final String username;
  final String service;
  final double rating;
  final String category;
  final double hourlyRate;
  const UserInfo(
      {super.key,
      required this.fullname,
      required this.username,
      required this.service,
      required this.rating,
      required this.category,
      required this .hourlyRate
      });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double xSAvatarHeight = screenHeight * 0.055;
    double cardWidth = screenWidth * 0.35;
    return Column(
      children: [
        //name and email
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //name
                Row(
                  children: [
                    Text(
                      fullname,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    const Icon(
                      Iconsax.verify,
                      color: Colors.amber,
                      size: Sizes.iconSm,
                    )
                  ],
                ),
            
                //email
                Text(username, style: Theme.of(context).textTheme.labelSmall)
              ],
            ),

            //hourly rate
            Text('\$${NumberFormat('#,##0.00').format(hourlyRate)}/hr',
            style: Theme.of(context).textTheme.bodySmall,)
          ],
        ),
        const SizedBox(
          height: Sizes.xs,
        ),

        //service and rating and settings button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //service rating and location
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //service
                    Text(
                      service,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(
                      width: Sizes.xs,
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: Sizes.iconXs,
                    ),

                    //rating
                    Text(
                      '$rating',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),

                //location
                Text(category,
                style: Theme.of(context).textTheme.labelMedium,),
              ],
            ),

            //edit button
            GestureDetector(
              onTap: () => HelperFunction.navigateScreen(context, SettingsScreen()),
              child: Container(
                height: xSAvatarHeight,
                width: cardWidth * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                    color: CustomColors.primary),
                padding: const EdgeInsets.all(2),
                child: Center(
                  child: Text(
                    'Settings',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
