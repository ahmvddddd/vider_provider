import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import 'package:intl/intl.dart';

import '../../../utils/helpers/helper_function.dart';

class UserInfo extends StatelessWidget {
  final String fullname;
  final String username;
  final String service;
  final double rating;
  final String category;
  final double hourlyRate;
  const UserInfo({
    super.key,
    required this.fullname,
    required this.username,
    required this.service,
    required this.rating,
    required this.category,
    required this.hourlyRate,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(Sizes.xs),
      child: Column(
        children: [
          //name and email
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
                  const SizedBox(width: 2),
                  const Icon(
                    Iconsax.verify,
                    color: Colors.amber,
                    size: Sizes.iconSm,
                  ),
                ],
              ),

              //email
              Text(username, style: Theme.of(context).textTheme.labelSmall!.copyWith(color: dark ? Colors.blue : CustomColors.primary)),
            ],
          ),

          //service and rating and settings button
          const SizedBox(height: Sizes.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    service,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(width: Sizes.xs),
                  const Icon(Icons.star, color: Colors.amber, size: Sizes.iconXs),

                  //rating
                  Text('$rating', style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
              Text(category, style: Theme.of(context).textTheme.bodySmall),

              //hourly rate
              const SizedBox(height: Sizes.sm),
              Text(
                '\$${NumberFormat('#,##0.00').format(hourlyRate)}/hr',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:vider_provider/utils/constants/sizes.dart';

// import '../../../utils/constants/custom_colors.dart';
// import '../../../utils/helpers/helper_function.dart';

// class UserInfo extends StatelessWidget {
//   final String profileImage;
//   final String fullname;
//   final String username;
//   final String service;
//   final double rating;
//   final String category;
//   final double hourlyRate;
//   const UserInfo({super.key, required this.profileImage,
//   required this.fullname,
//   required this.username,
//   required this.service,
//   required this.rating,
//   required this.category,
//   required this.hourlyRate});

//   @override
//   Widget build(BuildContext context) {
//     final dark = HelperFunction.isDarkMode(context);
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(Sizes.cardRadiusSm),
//         color:
//             dark
//                 ? Colors.white.withValues(alpha: 0.1)
//                 : Colors.black.withValues(alpha: 0.1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           //profileImage
//           ClipRRect(
//             borderRadius: BorderRadius.circular(Sizes.cardRadiusSm),
//             child: SizedBox(
//               height: screenHeight * 0.30,
//               width: screenWidth * 0.90,
//               child: Image.network(
//                 profileImage,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           //name
//           const SizedBox(height: Sizes.sm),
//           Padding(
//             padding: const EdgeInsets.all(Sizes.sm),
//             child: Column(
//               children: [
//                 Row(
//               children: [
//                 Text(fullname, style: Theme.of(context).textTheme.headlineSmall),
//                 const SizedBox(width: 2),
//                 const Icon(
//                   Iconsax.verify,
//                   color: Colors.amber,
//                   size: Sizes.iconSm,
//                 ),
//               ],
//             ),
//             Text(username, style: Theme.of(context).textTheme.labelSmall!.copyWith(color: dark ? Colors.blue : CustomColors.primary)),
            
//             //service and rating and settings button
//             const SizedBox(height: Sizes.xs),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       service,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     const SizedBox(width: Sizes.xs),
//                     const Icon(Icons.star, color: Colors.amber, size: Sizes.iconXs),
            
//                     //rating
//                     Text('$rating', style: Theme.of(context).textTheme.labelLarge),
//                   ],
//                 ),
//                 Text(category, style: Theme.of(context).textTheme.bodySmall),
            
//                 //hourly rate
//                 const SizedBox(height: Sizes.sm),
//                 Text(
//                   '\$${NumberFormat('#,##0.00').format(hourlyRate)}/hr',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyLarge,
//                 ),
//               ],
//             ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
