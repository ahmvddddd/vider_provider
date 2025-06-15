// ignore_for_file: unnecessary_null_comparison, unnecessary_to_list_in_spreads

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../common/widgets/texts/title_and_description.dart';
import '../../controllers/uploads/portfolio_images_controller.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import '../../utils/helpers/token_secure_storage.dart';

class PortfolioUploadScreen extends ConsumerStatefulWidget {
  const PortfolioUploadScreen({super.key});

  @override
  ConsumerState<PortfolioUploadScreen> createState() =>
      _PortfolioUploadScreenState();
}

class _PortfolioUploadScreenState extends ConsumerState<PortfolioUploadScreen> {
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        _selectedImages.clear();
        _selectedImages.addAll(picked.take(4).map((x) => File(x.path)));
      });
    }
  }

  void _upload() async {
    await TokenSecureStorage.checkToken(context: context, ref: ref);
    ref
        .read(portfolioUploadControllerProvider.notifier)
        .uploadImages(context, _selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final uploadState = ref.watch(portfolioUploadControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            'Upload Portfolio Images',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          showBackArrow: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleAndDescription(
                  textAlign: TextAlign.left,
                  title: 'Upload Portfolio Images',
                  description:
                      'Upload 4 clear images that display the service you provide. Do not uploadother users images as this could lead to suspension of your account',
                ),

                const SizedBox(height: Sizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                        backgroundColor: CustomColors.primary,
                      ),
                      onPressed: _pickImages,
                      child: Text(
                        'Select 4 Images',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: Sizes.spaceBtwItems),
                if (_selectedImages.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _selectedImages
                            .map(
                              (file) => RoundedContainer(
                                backgroundColor: Colors.transparent,
                                radius: Sizes.cardRadiusSm,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Sizes.md),
                                  child: Image.file(
                                    file,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),

                const SizedBox(height: Sizes.spaceBtwItems),
                uploadState.when(
                  data:
                      (urls) =>
                          urls.isNotEmpty
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Uploaded Successfully',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  uploadState.isLoading
                                      ? Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.blue,
                                              ), // color
                                          strokeWidth:
                                              4.0, // thickness of the line
                                          backgroundColor:
                                              dark
                                                  ? Colors.white
                                                  : Colors
                                                      .black, // background circle color
                                        ),
                                      )
                                      : TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(
                                            Sizes.spaceBtwItems,
                                          ),
                                          backgroundColor: CustomColors.primary,
                                        ),
                                        onPressed: _upload,
                                        child: Text(
                                          'Upload',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                ],
                              ),
                  loading: () => const CircularProgressIndicator(),
                  error:
                      (e, _) => Center(
                        child: Text(
                          'An error occured failed to upload portfolio images',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
