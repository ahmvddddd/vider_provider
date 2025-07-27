import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../common/widgets/list_tile/settings_menu_tile.dart';
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
      backgroundColor:
          dark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
      child: Column(
        children: [
          const SizedBox(height: Sizes.xs),

          SettingsMenuTile(
            icon: Iconsax.bank,
            title: 'Transactions',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(
                  context,
                  TransactionHistory(),
                ),
          ),

          const SizedBox(height: Sizes.sm),
          ListTile(
            leading: Icon(
              Icons.location_on,
              color: CustomColors.primary,
              size: Sizes.iconM,
            ),
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

          const SizedBox(height: Sizes.sm),
          SettingsMenuTile(
            icon: Icons.change_circle,
            title: ' ChangeSubscription Plan',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(
                  context,
                  SubscriptionPlanScreen(),
                ),
          ),
          const SizedBox(height: Sizes.sm),
          SettingsMenuTile(
            icon: Icons.image,
            title: 'Update Portfolio Images',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(
                  context,
                  UpdateProfileImagesPage(),
                ),
          ),
          const SizedBox(height: Sizes.sm),
          SettingsMenuTile(
            icon: Iconsax.user,
            title: 'Update Bio',
            subTitle: '',
            onTap: () => HelperFunction.navigateScreen(context, UpdateBio()),
          ),
          const SizedBox(height: Sizes.sm),
          SettingsMenuTile(
            icon: Icons.timelapse,
            title: 'Update Hourly Rate',
            subTitle: '',
            onTap:
                () =>
                    HelperFunction.navigateScreen(context, UpdateHourlyRate()),
          ),
          const SizedBox(height: Sizes.sm),
          SettingsMenuTile(
            icon: Icons.shape_line,
            title: 'Update Skills',
            subTitle: '',
            onTap: () => HelperFunction.navigateScreen(context, UpdateSkills()),
          ),
          const SizedBox(height: Sizes.sm),
          SettingsMenuTile(
            icon: Icons.list,
            title: 'Update Category & Service',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(
                  context,
                  UpdateCategoryAndService(),
                ),
          ),
        ],
      ),
    );
  }
}
