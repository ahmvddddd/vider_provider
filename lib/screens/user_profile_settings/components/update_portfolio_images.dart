import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/layouts/listvew.dart';
import '../../../common/widgets/pop_up/custom_snackbar.dart';
import '../../../controllers/uploads/portfolio_images_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class UpdateProfileImagesPage extends ConsumerStatefulWidget {
  const UpdateProfileImagesPage({super.key});

  @override
  ConsumerState<UpdateProfileImagesPage> createState() =>
      _UpdateProfileImagesPageState();
}

class _UpdateProfileImagesPageState
    extends ConsumerState<UpdateProfileImagesPage> {
  final ImagePicker _picker = ImagePicker();
  List<File?> newImages = List.filled(4, null);
  List<String> existingImageUrls = [];

  Future<void> _pickImage(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => newImages[index] = File(picked.path));
    }
  }

  Future<void> _replaceImage(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        newImages[index] = File(picked.path);
        existingImageUrls[index] = ''; // Clear deleted one
      });
    }
  }

  Future<void> _saveImages() async {
    final Map<int, File> imagesToUpload = {};
    for (int i = 0; i < newImages.length; i++) {
      final image = newImages[i];
      if (image != null) {
        imagesToUpload[i] = image;
      }
    }

    if (imagesToUpload.isEmpty) {
       CustomSnackbar.show(
                          context: context,
                          title: 'Error',
                          message: 'No images to update',
                          icon: Icons.error_outline,
                          backgroundColor: CustomColors.error,
                        );
      return;
    }

    try {
      await ref.read(userPortfolioUpdateProvider(imagesToUpload).future);
      CustomSnackbar.show(
                          context: context,
                          title: 'Success',
                          message: 'Updated portfolio images successfully',
                          icon: Icons.check_circle,
                          backgroundColor: CustomColors.success,
                        );

      // Reset state
      setState(() {
        for (int i in imagesToUpload.keys) {
          newImages[i] = null;
        }
      });
    } catch (e) {
      CustomSnackbar.show(
                          context: context,
                          title: 'An error occured',
                          message: 'Failed to update images',
                          icon: Icons.error_outline,
                          backgroundColor: CustomColors.error,
                        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final dark = HelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Update Portfolio Images',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: userAsync.when(
        data: (user) {
          existingImageUrls = List.from(user.portfolioImages);
          return Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              children: [
                HomeListView(
                  scrollDirection: Axis.horizontal,
                  sizedBoxHeight: screenHeight * 0.12,
                  itemCount: 4,
                  seperatorBuilder:
                      (context, index) => const SizedBox(width: Sizes.sm),
                  itemBuilder: (context, index) {
                    final imageFile = newImages[index];
                    final imageUrl =
                        existingImageUrls.length > index
                            ? existingImageUrls[index]
                            : null;

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap:
                              () =>
                                  imageFile == null ? _pickImage(index) : null,
                          child: RoundedContainer(
                            width: screenHeight * 0.12,
                            height: screenHeight * 0.12,
                            backgroundColor:
                                dark ? Colors.white12 : Colors.black12,
                            padding: EdgeInsets.zero,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Sizes.md),
                              child:
                                  imageFile != null
                                      ? Image.file(imageFile, fit: BoxFit.cover)
                                      : (imageUrl != null &&
                                          imageUrl.isNotEmpty)
                                      ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(
                                        Icons.add_photo_alternate,
                                        size: 40,
                                      ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () async {
                              await _replaceImage(index);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                      backgroundColor: CustomColors.primary,
                    ),
                    onPressed: _saveImages,
                    child: Text(
                      'Update Portfolio Images',
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
        error: (err, _) => Center(child: Text('An error occured failed to update portfolio images',
              style: Theme.of(context).textTheme.bodySmall,)),
      ),
    );
  }
}
