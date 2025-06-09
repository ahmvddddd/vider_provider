// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../../../../utils/constants/sizes.dart';
// import 'title_and_description.dart';

// class UserId extends StatefulWidget {
//   const UserId({super.key});

//   @override
//   State<UserId> createState() => _UserIdState();
// }

// class _UserIdState extends State<UserId> {
//   final ImagePicker idPicker = ImagePicker();
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//   XFile? idImage;

//   String selectedOption = 'Drivers License';
//   List<String> idType = [
//     'Drivers License',
//     'National Id',
//     'International Passport'
//   ];

//   Future<void> getImage() async{
//     final XFile? image = await idPicker.pickImage(source: ImageSource.gallery);
//     setState((){
//       idImage = image;
//     }
//     );
    
//   }

//   // Function to upload the image
//   Future<void> _uploadImage() async {
//     if (idImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image first')),
//       );
//       return;
//     }

//     try {
//       // Get the token from secure storage
//       String? token = await _secureStorage.read(key: 'token');

//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Token not found. Please login again.')),
//         );
//         return;
//       }

//       // Create a multipart request
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://localhost:3000/api/uploadimage'),
//       );

//       // Add the image file to the request
//       request.files.add(await http.MultipartFile.fromPath(
//         'profileImage',
//         idImage!.path,
//       ));

//       // Add authorization header
//       request.headers['Authorization'] = 'Bearer $token';

//       // Send the request
//       var response = await request.send();

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile image uploaded successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to upload image')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $e')),
//       );
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     return  Column(
//       children: [
//         //User Id
//               const TitleAndDescription(
//                 title: 'Id Image',
//                 description: 'Tap the button bellow to upload an image of your Identity card',
//               ),
//               const SizedBox(height: Sizes.spaceBtwItems),
//               DropdownButton(
//                 value: selectedOption,
//                 items: idType.map((String option){
//                 return DropdownMenuItem(
//                   value: option,
//                   child: Text(option,
//                   style: Theme.of(context).textTheme.labelSmall,));
//               }
//               ).toList(),
//                onChanged: (String? newValue) {
//                 setState(() {
//                   selectedOption = newValue!;
//                 });
//                }),
      
//               const SizedBox(height: Sizes.spaceBtwSections),
//               idImage == null ? Text('No Image Selected',
//               style: Theme.of(context).textTheme.labelLarge)
//               : Container(
//                     height: screenHeight * 0.20,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(Sizes.borderRadiusMd)
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
//                   child: Image.file(
//                     File(idImage!.path),
//                     height: screenHeight * 0.20,
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: Sizes.sm,),
//               SizedBox(
//                 width: screenWidth * 0.30,
//                 height: screenHeight * 0.05,
//                 child: ElevatedButton(
//                   onPressed: getImage,
//                   child: Text('Select Image',
//               style: Theme.of(context).textTheme.labelSmall,),
//                 ),
//               ),

//               const SizedBox(height: Sizes.spaceBtwItems),
//                     ElevatedButton(
//                       onPressed: () {
//                         _uploadImage();
//                       },
//                       child: Text('AmountToWordsPage', style: Theme.of(context).textTheme.labelSmall,),
//                     ),
//       ],
//     );
//   }
// }