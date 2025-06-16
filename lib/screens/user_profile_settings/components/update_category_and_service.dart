import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/pop_up/custom_snackbar.dart';
import '../../../controllers/auth/user_bio_controller.dart';
import '../../../controllers/user/update_profile_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class UpdateCategoryAndService extends ConsumerStatefulWidget {
  const UpdateCategoryAndService({super.key});

  @override
  ConsumerState<UpdateCategoryAndService> createState() =>
      _UpdateCategoryAndServiceState();
}

class _UpdateCategoryAndServiceState
    extends ConsumerState<UpdateCategoryAndService> {
  String? selectedCategory;
  String? selectedService;
  List<String> serviceList = [];

  @override
  Widget build(BuildContext context) {
    final occupationsAsync = ref.watch(occupationsProvider);
    final dark = HelperFunction.isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            'Update Category & Service',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          showBackArrow: true,
        ),
        body: occupationsAsync.when(
          data: (occupations) {
            return Padding(
              padding: const EdgeInsets.all(Sizes.spaceBtwItems),
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: selectedCategory,
                isExpanded: true,
                    hint: Text(
                      'Select Category',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    items:
                        occupations.map<DropdownMenuItem<String>>((occupation) {
                          return DropdownMenuItem(
                            value: occupation['category'],
                            child: Text(occupation['category'],
                            style: Theme.of(context).textTheme.labelMedium
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        final selected = occupations.firstWhere(
                          (o) => o['category'] == value,
                        );
                        serviceList = List<String>.from(selected['service']);
                        selectedService = null;
                      });
                    },
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  DropdownButton<String>(
                    value: selectedService,
                isExpanded: true,
                    hint: Text(
                      'Select Service',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    items:
                        serviceList.map((service) {
                          return DropdownMenuItem(
                            value: service,
                            child: Text(service,
                            style: Theme.of(context).textTheme.labelMedium),
                          );
                        }).toList(),
                    onChanged: (value) => setState(() => selectedService = value),
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                        backgroundColor:
                            (selectedCategory == null || selectedService == null)
                                ? dark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.1)
                                : CustomColors.primary,
                      ),
                      onPressed:
                          (selectedCategory == null || selectedService == null)
                              ? null
                              : () async {
                                final success = await ref.read(
                                  updateBioData({
                                    'category': selectedCategory,
                                    'service': selectedService,
                                  }).future,
                                );
      
                                if (success) {
                            CustomSnackbar.show(
                              context: context,
                              title: 'Success',
                              message: 'Category and service updated successfully',
                              icon: Icons.check_circle,
                              backgroundColor: CustomColors.success,
                            );
                            Navigator.pop(context);
                          } else {
                            CustomSnackbar.show(
                              context: context,
                              title: 'An error occurred',
                              message: 'Failed to update category and service',
                              icon: Icons.error_outline,
                              backgroundColor: CustomColors.error,
                            );
                          }
                              },
                      child: Text(
                        'Update Category and Service',
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
          loading: () => Center(
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
              (err, _) => Center(child: Text('Error loading categories: $err')),
        ),
      ),
    );
  }
}
