import 'dart:io'show File;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../controllers/uploads/profile_image_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/token_secure_storage.dart';

class UploadProfileImagePage extends ConsumerWidget {
  const UploadProfileImagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(profileImageControllerProvider.notifier);
    final image = controller.capturedImage;
    final isCameraReady = controller.isCameraInitialized;
    final camera = controller.cameraController;

    return Scaffold(
      appBar: TAppBar(
        title: Text('Upload Profile Image',
            style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: ref.watch(profileImageControllerProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (_) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                children: [
                  image == null
                      ? isCameraReady
                          ? RoundedContainer(
                              backgroundColor: Colors.transparent,
                              borderColor: CustomColors.primary,
                              child: AspectRatio(
                                aspectRatio: camera!.value.aspectRatio,
                                child: CameraPreview(camera),
                              ),
                            )
                          : const CircularProgressIndicator()
                      : CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(File(image.path)),
                        ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  ElevatedButton(
                    onPressed: () => controller.captureImage(),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(Sizes.xs),
                        backgroundColor: CustomColors.primary),
                    child: Text(
                      image == null ? 'Take Picture' : 'Retake Picture',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  ElevatedButton(
                    onPressed: () async {
                      await TokenSecureStorage.checkToken(context: context, ref: ref);
                        await controller.uploadImage(context);
                    },
                    child: Text(
                      'Upload Image',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}