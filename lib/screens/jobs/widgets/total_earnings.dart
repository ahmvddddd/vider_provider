import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/reponsive_size.dart';

class TotalEarnings extends StatelessWidget {
  final double totalPay;
  final Color starColor;
  final String star;
  const TotalEarnings({
    super.key,
    required this.totalPay,
    required this.starColor,
    required this.star,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.90,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.bg1),
          fit: BoxFit.cover,
        ),
        // color: dark ? Colors.white.withValues(alpha:0.1) : Colors.black.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(Sizes.cardRadiusSm),
      ),
      padding: EdgeInsets.all(responsiveSize(context, Sizes.sm)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Earnings',
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.copyWith(color: Colors.white),
          ),
          SizedBox(height: responsiveSize(context, Sizes.xs)),
          Text(
            '\$${NumberFormat('#,##0.00').format(totalPay)}',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: Colors.white),
          ),
          SizedBox(height: responsiveSize(context, Sizes.md)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: responsiveSize(context, Sizes.spaceBtwItems)),
              Container(
                padding: const EdgeInsets.all(Sizes.sm),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Sizes.cardRadiusXs),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: starColor, size: Sizes.iconM),
                    const SizedBox(width: Sizes.xs),
                    Text(
                      star,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: CustomColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
