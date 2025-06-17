import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../common/widgets/list_tile/settings_menu_tile.dart';
import '../../controllers/user/save_location_controller.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import '../transactions/validate_pin_screen.dart';
import 'components/update_bio.dart';
import 'components/update_category_and_service.dart';
import 'components/update_hourly_rate.dart';
import 'components/update_portfolio_images.dart';
import 'components/update_skills.dart';

class UpdateUserProfilePage extends ConsumerWidget {
  const UpdateUserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = HelperFunction.isDarkMode(context);
    final isOn = ref.watch(locationSwitchProvider);

    return Column(
      children: [
        const SizedBox(height: Sizes.spaceBtwItems),
        RoundedContainer(
          backgroundColor: dark ? Colors.white.withValues(alpha: 0.1) 
          : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.xs),
          child: ListTile(
          leading: Icon(
            Icons.location_on,
            color: CustomColors.primary,
            size: Sizes.iconM,
          ),
          title: Text(
            'Location',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          trailing: Switch(
            value: isOn,
            onChanged: (value) {
  ref.read(locationSwitchProvider.notifier).setSwitch(value);
  Future.microtask(() async {
    await ref.read(saveLocationProvider).getAndSaveLocation(context);
  });
},

          ),
        ),
        ),



        const SizedBox(height: Sizes.spaceBtwItems),
        RoundedContainer(
          backgroundColor: dark ? Colors.white.withValues(alpha: 0.1) 
          : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.xs),
          child: SettingsMenuTile(
            iconSize: Sizes.iconMd,
            icon: Icons.change_circle,
            title: ' ChangeSubscription Plan',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(context, ValidatePinScreen()),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        RoundedContainer(
          backgroundColor: dark ? Colors.white.withValues(alpha: 0.1) 
          : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.xs),
          child: SettingsMenuTile(
            iconSize: Sizes.iconMd,
            icon: Icons.image,
            title: 'Update Portfolio Images',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(context, UpdateProfileImagesPage())
                ),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        RoundedContainer(
          backgroundColor: dark ? Colors.white.withValues(alpha: 0.1) 
          : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.xs),
          child: SettingsMenuTile(
            iconSize: Sizes.iconMd,
            icon: Iconsax.user,
            title: 'Update Bio',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(context, UpdateBio()),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        RoundedContainer(
          backgroundColor: dark ? Colors.white.withValues(alpha: 0.1) 
          : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.xs),
          child: SettingsMenuTile(
            iconSize: Sizes.iconMd,
            icon: Icons.timelapse,
            title: 'Update Hourly Rate',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(context, UpdateHourlyRate()),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        RoundedContainer(
          backgroundColor: dark ? Colors.white.withValues(alpha: 0.1) 
          : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.xs),
          child: SettingsMenuTile(
            iconSize: Sizes.iconMd,
            icon: Icons.shape_line,
            title: 'Update Skills',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(context, UpdateSkills()),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        RoundedContainer(
          backgroundColor: dark ? Colors.white.withValues(alpha: 0.1) 
          : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.xs),
          child: SettingsMenuTile(
            iconSize: Sizes.iconM,
            icon: Icons.list,
            title: 'Update Category & Service',
            subTitle: '',
            onTap:
                () => HelperFunction.navigateScreen(context, UpdateCategoryAndService()),
          ),
        ),
      ],
    );
  }
}
