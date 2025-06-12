import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/inputs/text_field_container.dart';
import '../../../common/widgets/pop_up/custom_snackbar.dart';
import '../../../controllers/user/update_profile_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';

class UpdateHourlyRate extends ConsumerStatefulWidget {
  const UpdateHourlyRate({super.key});

  @override
  ConsumerState<UpdateHourlyRate> createState() => _UpdateHourlyRateState();
}

class _UpdateHourlyRateState extends ConsumerState<UpdateHourlyRate> {
  final TextEditingController hourlyRateController = TextEditingController();
  String? errorText;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref
          .read(userProvider)
          .maybeWhen(data: (u) => u, orElse: () => null);
      if (user != null) hourlyRateController.text = user.hourlyRate.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProvider);
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Update Hourly Rate',
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
                  controller: hourlyRateController,
                  hintText: 'Enter your hourly rate (Min \$5)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  errorText: errorText,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: CustomColors.primary,
                    ),
                    onPressed: () async {
                      final rate = double.tryParse(
                        hourlyRateController.text.trim(),
                      );
                      setState(() {
                        errorText =
                            (rate == null || rate < 5)
                                ? 'Enter a valid hourly rate (min \$5)'
                                : null;
                      });
                      if (errorText == null) {
                        final success = await ref.read(
                          updateBioData({'hourlyRate': rate}).future,
                        );

                        if (success) {
                          CustomSnackbar.show(
                            context: context,
                            title: 'Success',
                            message: 'Hourly rate updated successfully',
                            icon: Icons.check_circle,
                            backgroundColor: CustomColors.success,
                          );
                          Navigator.pop(context);
                        } else {
                          CustomSnackbar.show(
                            context: context,
                            title: 'An error occurred',
                            message: 'Failed to update hourly rate',
                            icon: Icons.error_outline,
                            backgroundColor: CustomColors.error,
                          );
                        }
                      }
                    },
                    child: Text(
                      'Update Rate',
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
