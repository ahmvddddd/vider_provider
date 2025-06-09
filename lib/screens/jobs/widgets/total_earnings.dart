import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_function.dart';

class TotalEarnings extends StatelessWidget {
  final double totalPay;
  final Color starColor;
  final String star;
  const TotalEarnings({super.key, required this.totalPay, required this.starColor, required this.star
  });
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final dark = HelperFunction.isDarkMode(context);
    return RoundedContainer(
      width: screenWidth * 0.90,
      backgroundColor:
          dark ? Colors.white.withValues(alpha:0.1) : Colors.black.withValues(alpha:0.1),
      radius: Sizes.cardRadiusSm,
      padding: const EdgeInsets.all(Sizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Earnings',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: Sizes.xs,
          ),
          Text(
            '\$${NumberFormat('#,##0.00').format(totalPay)}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: Sizes.spaceBtwItems,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                width: Sizes.md,
              ),
              Container(
                padding: const EdgeInsets.all(Sizes.sm),
                decoration: BoxDecoration(
                    color: CustomColors.primary,
                    borderRadius: BorderRadius.circular(Sizes.cardRadiusXs)),
                child: Row(
                  children: [
                    Icon(Icons.star,
                    color: starColor,
                    size: Sizes.iconM,),
                    const SizedBox(width: Sizes.xs,),
                    Text(
                      star,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
