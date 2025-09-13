import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../controllers/user/save_location_controller.dart';
import '../../repository/user/location_state_storage.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import '../settings/components/subscription_plan_screen.dart';
import '../transactions/transaction_history.dart';
import 'components/update_bio.dart';
import 'components/update_category_and_service.dart';
import 'components/update_hourly_rate.dart';
import 'components/update_portfolio_images.dart';
import 'components/update_skills.dart';

class UpdateUserProfilePage extends ConsumerWidget {
  const UpdateUserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocationEnabled = ref.watch(persistentLocationSwitchProvider);
    final switchController = ref.read(
      persistentLocationSwitchProvider.notifier,
    );
    final locationController = ref.read(saveLocationProvider);
    final dark = HelperFunction.isDarkMode(context);
    return RoundedContainer(
      padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBtwItems),
      boxShadow: [
        BoxShadow(
          color: dark ? CustomColors.darkerGrey : CustomColors.darkGrey,
          blurRadius: 5,
          spreadRadius: 0.5,
          offset: const Offset(0, 1),
        ),
      ],
      backgroundColor: dark ? Colors.black : Colors.white,
      child: Column(
        children: [
          _settingsTile(
            context,
            () => HelperFunction.navigateScreen(context, TransactionHistory()),
            Iconsax.bank,
            'Transactions',
            'View all recent transactions',
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.sm,
              horizontal: Sizes.spaceBtwSections,
            ),
            child: Divider(
              color: dark ? CustomColors.alternate : CustomColors.primary,
            ),
          ),

          ListTile(
            leading: Icon(Icons.location_on, size: Sizes.iconM),
            title: Text(
              'Location',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            trailing: Switch(
              value: isLocationEnabled,
              onChanged: (value) async {
                await switchController.setSwitch(
                  value,
                ); // update state + save to shared prefs
                Future.microtask(() async {
                  await locationController.getAndSaveLocation(context);
                }); // send to backend
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.sm,
              horizontal: Sizes.spaceBtwSections,
            ),
            child: Divider(
              color: dark ? CustomColors.alternate : CustomColors.primary,
            ),
          ),
          _settingsTile(
            context,
            () => HelperFunction.navigateScreen(
              context,
              SubscriptionPlanScreen(),
            ),
            Icons.change_circle,
            'Subscription Plan',
            'Revew and change your subscription plan',
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.sm,
              horizontal: Sizes.spaceBtwSections,
            ),
            child: Divider(
              color: dark ? CustomColors.alternate : CustomColors.primary,
            ),
          ),
          _settingsTile(
            context,
            () => HelperFunction.navigateScreen(
              context,
              UpdateProfileImagesPage(),
            ),
            Icons.image,
            'Portfolio Images',
            'Update your portfoliomages',
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.sm,
              horizontal: Sizes.spaceBtwSections,
            ),
            child: Divider(
              color: dark ? CustomColors.alternate : CustomColors.primary,
            ),
          ),
          _settingsTile(
            context,
            () => HelperFunction.navigateScreen(context, UpdateBio()),
            Iconsax.user,
            'Update Bio',
            'Review and update your bio',
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.sm,
              horizontal: Sizes.spaceBtwSections,
            ),
            child: Divider(
              color: dark ? CustomColors.alternate : CustomColors.primary,
            ),
          ),
          _settingsTile(
            context,
            () => HelperFunction.navigateScreen(context, UpdateHourlyRate()),
            Icons.timelapse,
            'Update Hourly Rate',
            'Review and update your hourly rate',
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.sm,
              horizontal: Sizes.spaceBtwSections,
            ),
            child: Divider(
              color: dark ? CustomColors.alternate : CustomColors.primary,
            ),
          ),
          _settingsTile(
            context,
            () => HelperFunction.navigateScreen(context, UpdateSkills()),
            Icons.shape_line,
            'Update Skills',
            'Review and update your skills',
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.sm,
              horizontal: Sizes.spaceBtwSections,
            ),
            child: Divider(
              color: dark ? CustomColors.alternate : CustomColors.primary,
            ),
          ),
          _settingsTile(
            context,
            () => HelperFunction.navigateScreen(
              context,
              UpdateCategoryAndService(),
            ),
            Icons.list,
            'Update Category & Service',
            'Review and update your category and skills',
          ),

          const SizedBox(height: Sizes.spaceBtwItems),
        ],
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context,
    VoidCallback onTap,
    IconData icon,
    String title,
    String subTitle,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.sm,
          horizontal: Sizes.spaceBtwItems,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: Sizes.iconM),

                const SizedBox(width: Sizes.spaceBtwItems),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.labelMedium),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Text(
                        subTitle,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Icon(Iconsax.arrow_right_1, size: Sizes.iconM),
          ],
        ),
      ),
    );
  }
}
