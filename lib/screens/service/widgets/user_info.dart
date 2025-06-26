import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import 'package:intl/intl.dart';

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
              Text(username, style: Theme.of(context).textTheme.labelSmall!.copyWith(color: CustomColors.primary)),
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
