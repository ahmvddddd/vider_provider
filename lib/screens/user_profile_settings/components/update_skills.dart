import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/layouts/listvew.dart';
import '../../../common/widgets/pop_up/custom_snackbar.dart';
import '../../../controllers/user/update_profile_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class UpdateSkills extends ConsumerStatefulWidget {
  const UpdateSkills({super.key});

  @override
  ConsumerState<UpdateSkills> createState() => _UpdateSkillsState();
}

class _UpdateSkillsState extends ConsumerState<UpdateSkills> {
  List<String> editableSkills = [];

  final TextEditingController _skillController = TextEditingController();

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final text = _skillController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        editableSkills.add(text);
        _skillController.clear();
      });
    }
  }

  void _deleteSkill(int index) {
    setState(() {
      editableSkills.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final dark = HelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Update Skills',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: userAsync.when(
        data: (user) {
          if (editableSkills.isEmpty) {
            editableSkills = List.from(user.skills); // Initialize once
          }
          return Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _skillController,
                        decoration: const InputDecoration(
                          labelText: 'Add Skill',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addSkill,
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                HomeListView(
                  scrollDirection: Axis.horizontal,
                  sizedBoxHeight: screenHeight * 0.1,
                  itemCount: editableSkills.length,
                  seperatorBuilder:
                      (context, index) => const SizedBox(width: Sizes.sm),
                  itemBuilder: (context, index) {
                    final skill = editableSkills[index];
                    return RoundedContainer(
                      height: screenHeight * 0.08,
                      backgroundColor:
                          dark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.1),
                      padding: const EdgeInsets.all(Sizes.xs),
                      child: Row(
                        children: [
                          Text(
                            skill,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 16,
                            ),
                            onPressed: () {
                              setState(() => _deleteSkill(index));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                      backgroundColor:
                          editableSkills.isEmpty
                              ? dark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.1)
                              : CustomColors.primary,
                    ),
                    onPressed:
                        editableSkills.isEmpty
                            ? null
                            : () async {
                              final success = await ref.read(
                                updateBioData({
                                  'skills': editableSkills,
                                }).future,
                              );

                              if (success) {
                          CustomSnackbar.show(
                            context: context,
                            title: 'Success',
                            message: 'Skills updated successfully',
                            icon: Icons.check_circle,
                            backgroundColor: CustomColors.success,
                          );
                          Navigator.pop(context);
                        } else {
                          CustomSnackbar.show(
                            context: context,
                            title: 'An error occurred',
                            message: 'Failed to update skills',
                            icon: Icons.error_outline,
                            backgroundColor: CustomColors.error,
                          );
                        }
                            },
                    child: Text(
                      'Update Skills',
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
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
