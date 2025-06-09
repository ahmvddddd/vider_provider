// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/inputs/text_field_container.dart';
import '../../../controllers/user/update_profile_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';

class UpdateBio extends ConsumerStatefulWidget {
  const UpdateBio({super.key});

  @override
  ConsumerState<UpdateBio> createState() => _UpdateBioState();
}

class _UpdateBioState extends ConsumerState<UpdateBio> {
  final TextEditingController bioController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProvider);

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Update Bio',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: userProfile.when(
        data: (user) {
          bioController.text = user.bio;
          return Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              children: [
                TextFieldContainer(
                  keyboardType: TextInputType.text,
                  controller: bioController,
                  hintText: 'Brief description about your services',
                  maxLines: 3,
                  maxLength: 200,
                  errorText: errorText,
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                      backgroundColor: CustomColors.primary,
                    ),
                    onPressed: () async {
                      setState(() {
                        errorText =
                            bioController.text.trim().isEmpty
                                ? 'Bio cannot be empty'
                                : null;
                      });
                      if (errorText == null) {
                        await ref.read(
                          updateBioData({
                            'bio': bioController.text.trim(),
                          }).future,
                        );
                      }
                    },
                    child: Text(
                      'Update Bio',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium!.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading profile: $err')),
      ),
    );
  }
}
