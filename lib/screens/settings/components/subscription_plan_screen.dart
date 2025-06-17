import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../controllers/user/subscription_plan_controller.dart';
import '../../../controllers/user/wallet_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../jobs/components/jobs_screen_shimmer.dart';

final selectedSubscriptionPlanProvider = StateProvider<String?>((ref) => null);


class SubscriptionPlanScreen extends ConsumerStatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  ConsumerState<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends ConsumerState<SubscriptionPlanScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(walletProvider.notifier).fetchBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletController = ref.watch(walletProvider);
    final selectedPlan = ref.watch(selectedSubscriptionPlanProvider);
    final controller = ref.read(subscriptionControllerProvider.notifier);

    return Scaffold(
      appBar: TAppBar(
          title: Text("Choose a Subscription Plan",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
      showBackArrow: true,),
      body: Padding(
          padding: const EdgeInsets.all(Sizes.spaceBtwItems),
          child: walletController.when(
            data: (wallet) {
              final currentPlan = wallet.subscriptionPlan.toLowerCase();
    
              return SingleChildScrollView(
                child: Column(
                  children: ['Free', 'Basic', 'Standard', 'Premium'].map((plan) {
                    final planLower = plan.toLowerCase();
                    final isSelected = selectedPlan?.toLowerCase() == planLower;
                    final isCurrent = currentPlan == planLower;
    
                    final showPrimary = isSelected || (selectedPlan == null && isCurrent);
    
                    String getPlanDescription(String plan) {
                      switch (plan.toLowerCase()) {
                        case 'free':
                          return 'Basic profile visibility. No platform boost.';
                        case 'basic':
                          return 'Better visibility. In app promotion.';
                        case 'standard':
                          return 'High visibility. Priority on listings. External publicity';
                        case 'premium':
                          return 'Maximum visibility, featured profile placement. Physical publicity and marketing campaign';
                        default:
                          return '';
                      }
                    }
    
    
                    return Column(
                      children: [
                        SubscriptionCard(
                          borderColor: showPrimary ? CustomColors.primary : Colors.transparent,
                          subscriptionPlan: plan,
                          percentage: getPercentage(plan),
                          subscriptionButton: isCurrent && selectedPlan == null
                              ? Align(
                            alignment: Alignment.center,
                                child: Text('Current Plan',
                                                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: CustomColors.primary),),
                              )
                              : ElevatedButton(
                            onPressed: () => controller.updateSubscriptionPlan(plan, context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: showPrimary ? Colors.transparent : CustomColors.primary,
                            ),
                            child: Text('Choose Plan',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                          ),
                            description: getPlanDescription(plan),
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const JobsScreenShimmer(),
            error: (e, _) => Center(
              child: Text(
                e.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
    );
  }

  double getPercentage(String plan) {
    switch (plan.toLowerCase()) {
      case 'free':
        return 10;
      case 'basic':
        return 15;
      case 'standard':
        return 20;
      case 'premium':
        return 30;
      default:
        return 0;
    }
  }
}


class SubscriptionCard extends StatelessWidget {
  final Color borderColor;
  final String subscriptionPlan;
  final double percentage;
  final Widget subscriptionButton;
  final String description;
  const SubscriptionCard({super.key,
    required this.borderColor,
    required this.subscriptionPlan,
    required this.percentage,
    required this.subscriptionButton,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
        border: Border.all(color: borderColor,
        width: 5),
        color: dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
      ),
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.08,
            width: screenWidth * 0.90,
            padding: const EdgeInsets.only(left: Sizes.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Sizes.cardRadiusLg),
                topRight: Radius.circular(Sizes.cardRadiusLg),
              ),
              color: dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(subscriptionPlan,
              style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text('$percentage% of earnings would be deducted for every payment you receive',
                  style: Theme.of(context).textTheme.labelSmall,
                  softWrap: true,
                  maxLines: 3,),

                const SizedBox(height: Sizes.sm,),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: screenWidth * 0.50,
                    child: subscriptionButton,
                  ),
                ),
                const SizedBox(height: Sizes.sm,),
                Text('$subscriptionPlan:',
                  style: Theme.of(context).textTheme.labelSmall,
                ),

                const SizedBox(height: Sizes.sm,),
                Text(description, // ✅ Show description here
                    style: Theme.of(context).textTheme.labelSmall,
                    softWrap: true,
                    maxLines: 3),

                const SizedBox(height: Sizes.sm)
              ],
            ),
          )
        ],
      )
    );
  }
}

