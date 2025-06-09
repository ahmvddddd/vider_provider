import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../utils/constants/custom_colors.dart';
import '../../../../utils/constants/sizes.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  
  CameraController? _controller;
   Future<void>? _initializeControllerFuture;
  XFile? _image;

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere((camera) =>
    camera.lensDirection == CameraLensDirection.front
    );
    _controller = CameraController(frontCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
  }


  // @override
  // void initState() {
  //   super.initState();
  //   _initializeCamera();
  // }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    await _initializeControllerFuture;
    _image = await _controller!.takePicture();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalCardHeight = screenHeight * 0.20;
    return Column(
      children: [
        //profile Image
              FutureBuilder<void>(future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      AspectRatio(aspectRatio: 1,
                      child: CameraPreview(_controller!),
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      IconButton(
                        onPressed: _takePicture,
                        icon: const Icon(Iconsax.camera,
                        color: Colors.white,
                        size: Sizes.iconMd
                        ),
                        style: IconButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: CustomColors.primary
                        )
                      ),

                      // ElevatedButton(onPressed: _takePicture, 
                      // child: Text('Take Picture',
                      // style: Theme.of(context).textTheme.labelSmall,)),

                      if (_image != null) ...[
                        Image.file(File(_image!.path)),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      Text('Image Path: ${_image!.path}',
                      style: Theme.of(context).textTheme.labelSmall,),
                      ]
                    ],
                  );
                } else {
                  return  Center(
                    child: 
                    GestureDetector(
                      onTap: _initializeCamera,
                      child: RoundedContainer(
                      width: horizontalCardHeight * 0.50,
                      height: horizontalCardHeight * 0.50,
                      radius: 100,
                      backgroundColor: CustomColors.primary.withValues(alpha: 0.5),
                      child: const Center(
                        child: Icon(Icons.add, size: Sizes.iconMd)),
                      ),
                    ),
                  );
                }
              },),
              const SizedBox(height: Sizes.sm),
              Text('Profile Picture',
              style: Theme.of(context).textTheme.labelSmall,),
      ],
    );
  }
}