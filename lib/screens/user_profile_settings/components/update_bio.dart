// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/inputs/text_field_container.dart';
import '../../../common/widgets/pop_up/custom_snackbar.dart';
import '../../../controllers/user/update_profile_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class UpdateBio extends ConsumerStatefulWidget {
  const UpdateBio({super.key});

  @override
  ConsumerState<UpdateBio> createState() => _UpdateBioState();
}

class _UpdateBioState extends ConsumerState<UpdateBio> {
  final TextEditingController bioController = TextEditingController();
  String? errorText;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref
          .read(userProvider)
          .maybeWhen(data: (u) => u, orElse: () => null);
      if (user != null) bioController.text = user.bio;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final userProfile = ref.watch(userProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            'Update Bio',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          showBackArrow: true,
        ),
        body: userProfile.when(
          data: (user) {
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
                          final success = await ref.read(
                            updateBioData({
                              'bio': bioController.text.trim(),
                            }).future,
                          );

                          if (success) {
                            CustomSnackbar.show(
                              context: context,
                              title: 'Success',
                              message: 'Bio updated successfully',
                              icon: Icons.check_circle,
                              backgroundColor: CustomColors.success,
                            );
                            Navigator.pop(context);
                          } else {
                            CustomSnackbar.show(
                              context: context,
                              title: 'An error occurred',
                              message: 'Failed to update bio',
                              icon: Icons.error_outline,
                              backgroundColor: CustomColors.error,
                            );
                          }
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
          loading:
              () => Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue,
                  ), // color
                  strokeWidth: 4.0, // thickness of the line
                  backgroundColor:
                      dark
                          ? Colors.white
                          : Colors.black, // background circle color
                ),
              ),
          error:
              (err, _) =>
                  Center(child: Text('An error occurred. Try again later')),
        ),
      ),
    );
  }
}
