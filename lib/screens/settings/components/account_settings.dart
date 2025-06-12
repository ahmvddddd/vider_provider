import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/list_tile/settings_menu_tile.dart';
import '../../../controllers/user/report_issue_controller.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../transactions/change_pin.dart';
import 'change_password.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);

    return Column(
      children: [
        const SizedBox(height: Sizes.spaceBtwItems),
        RoundedContainer(
          backgroundColor: dark ? Colors.white.withValues(alpha: 0.1) 
          : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
          padding: const EdgeInsets.all(Sizes.xs),
          child: SettingsMenuTile(
            iconSize: Sizes.iconMd,
            onTap:
                () => HelperFunction.navigateScreen(context, ChangePasswordPage()),
            icon: Iconsax.password_check,
            title: 'Password',
            subTitle: 'Change password.',
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
            onTap:
                () => HelperFunction.navigateScreen(context, ChangePinPage()),
            icon: Iconsax.security_card,
            title: 'Change Pin',
            subTitle: 'Change your transaction pin',
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
            onTap: () async {
              ReportIssueController.launchGmailCompose('Report An Issue');
            },
            icon: Iconsax.security_safe,
            title: 'Safety',
            subTitle: 'Report a failed transaction or a problem.',
          ),
        ),
      ],
    );
  }
}
