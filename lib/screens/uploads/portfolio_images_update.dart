// // ignore_for_file: unnecessary_null_comparison

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../controllers/auth/portfolio_images_controller.dart';

// class UpdatePortfolioPage extends ConsumerStatefulWidget {
//   const UpdatePortfolioPage({super.key});

//   @override
//   ConsumerState<UpdatePortfolioPage> createState() => _UpdatePortfolioPageState();
// }

// class _UpdatePortfolioPageState extends ConsumerState<UpdatePortfolioPage> {
//   final List<File> _newImages = [];
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImages() async {
//     final picked = await _picker.pickMultiImage(imageQuality: 80);
//     if (picked != null && picked.isNotEmpty) {
//       setState(() {
//         _newImages.clear();
//         _newImages.addAll(picked.take(4).map((x) => File(x.path)));
//       });
//     }
//   }

//   void _submitUpdate() {
//     ref.read(updatePortfolioControllerProvider.notifier).updateImages(_newImages);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final updateState = ref.watch(updatePortfolioControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Portfolio'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               'Select up to 4 new images to replace your portfolio.',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: _pickImages,
//               icon: const Icon(Icons.image),
//               label: const Text('Pick New Images'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (_newImages.isNotEmpty)
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: _newImages
//                     .map((file) => ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
//                         ))
//                     .toList(),
//               ),
//             const SizedBox(height: 24),
//             updateState.when(
//               data: (urls) => urls.isNotEmpty
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Updated Images:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 8),
//                         Wrap(
//                           spacing: 8,
//                           children: urls
//                               .map((url) => Image.network(url, width: 80, height: 80, fit: BoxFit.cover))
//                               .toList(),
//                         ),
//                       ],
//                     )
//                   : ElevatedButton(
//                       onPressed: _submitUpdate,
//                       child: const Text('Update Portfolio'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurple,
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//               loading: () => const CircularProgressIndicator(),
//               error: (e, _) => Text('Update failed: $e'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
