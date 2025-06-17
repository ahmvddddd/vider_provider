import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/texts/section_heading.dart';
import '../../controllers/auth/sign_out_controller.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import 'components/account_info.dart';
import '../user_profile_settings/update_user_profile_screen.dart';
import 'components/account_settings.dart';
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    final signoutController = ref.read(signoutControllerProvider.notifier);

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceBtwItems),
          child: Column(
            children: [
              AccountInfo(),
        
                    
              const SizedBox(height: Sizes.spaceBtwSections,),
              TSectionHeading(
                title: 'User Profile Settings',
                showActionButton: false,
              ),
              const SizedBox(height: Sizes.sm),
              UpdateUserProfilePage(),
        
              const SizedBox(height: Sizes.spaceBtwSections,),
              TSectionHeading(
                title: 'General Settings',
                showActionButton: false,
              ),
              const SizedBox(height: Sizes.sm),
              AccountSettingsPage(),
    
              const SizedBox(
                height: Sizes.spaceBtwSections,
              ),
              SizedBox(
                width: screenWidth * 0.90,
                child: ElevatedButton(
                    onPressed: () {
                      
    signoutController.signOut(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primary),
                    child: Text('Signout',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
