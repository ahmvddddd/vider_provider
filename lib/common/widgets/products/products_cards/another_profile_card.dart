// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:iconsax/iconsax.dart';
// import '../../../../../utils/constants/image_strings.dart';
// import '../../../../../utils/constants/custom_colors.dart';
// import '../../../../../utils/constants/sizes.dart';
// import '../../../../../utils/helpers/helper_function.dart';
// import 'service_provider.dart';

// class AnotherProfileCard extends StatefulWidget {
//   const AnotherProfileCard({super.key});

//   @override
//   State<AnotherProfileCard> createState() => _AnotherProfileCardState();
// }

// class _AnotherProfileCardState extends State<AnotherProfileCard> {
//   List<dynamic> profileList = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchProfiles();
//   }

//   Future<void> fetchProfiles() async {

//     final response = await http.get(
//       Uri.parse('http://localhost:3000/api/userprofiles'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         profileList = jsonDecode(response.body);
//         isLoading = false;
//       });
//     } else {
//       // Handle error response
//       print('Failed to fetch portfolio: ${response.body}');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth= MediaQuery.of(context).size.width;
//     final dark = HelperFunction.isDarkMode(context);
//     return Column(
//       children: [
//         const SizedBox(
//                   height: Sizes.spaceBtwItems,
//                 ),
//                 const TSectionHeading(
//                   title: 'Top Rated',
//                   showActionButton: false,
//                 ),

//                 const SizedBox(height: Sizes.sm),
//                 HomeListView(
//                     sizedBoxHeight: screenHeight * 0.45,
//                     scrollDirection: Axis.horizontal,
//                     seperatorBuilder: (context, index) =>
//                         const SizedBox(width: Sizes.sm),
//                     itemCount: profileList.length,
//                     itemBuilder: (context, index)  {
//                       final profiles = profileList[index];
//                       final firstname = profiles['firstname'];
//                       final lastname = profiles['lastname'];
//                       final service = profiles['service'];
//                       return GestureDetector(
//       onTap: () {
//         Navigator.push(context, 
//         MaterialPageRoute(builder: (context)
//         =>  ServiceProviderScreen(profiles: profiles)));
//       },
//       child: RoundedContainer(
//           width: screenWidth * 0.65,
//           padding: const EdgeInsets.all(Sizes.xs),
//           radius: Sizes.cardRadiusLg,
//           backgroundColor: dark ? CustomColors.dark : CustomColors.light,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //serviceImage
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
//                 child: Container(
//                   width: screenWidth * 0.65,
//                   height: screenHeight * 0.30,
//                   decoration: BoxDecoration(
//                     color: dark ? CustomColors.black : CustomColors.white,
//                     borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
//                   ),
//                   child: Image.asset(
//                     Images.chef,
//                     height: screenHeight * 0.35,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),

//               //profileImage, name and rating
//               const SizedBox(height: Sizes.xs),
//               Padding(
//                 padding: const EdgeInsets.all(Sizes.xs),
//                 child: Row(
//                   children: [
//                     Container(
//                       height: screenHeight * 0.04,
//                       padding: const EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: dark ? CustomColors.black : CustomColors.white,
//                       ),
//                       child: Image.asset(Images.avatarM1,
//                           height: screenHeight * 0.035, fit: BoxFit.cover),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     Text(
//                       '$firstname $lastname',
//                       style: Theme.of(context).textTheme.labelMedium,
//                     ),
//                     const SizedBox(
//                       width: 2,
//                     ),
//                     const Icon(
//                       Iconsax.verify,
//                       color: Colors.amber,
//                       size: Sizes.iconSm,
//                     )
//                   ],
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: Sizes.xs, vertical: Sizes.sm),
//                 child: Container(
//                   height: screenHeight * 0.04,
//                   decoration: BoxDecoration(
//                       borderRadius:
//                           BorderRadius.circular(Sizes.borderRadiusMd),
//                       color: CustomColors.primary),
//                   padding: const EdgeInsets.all(Sizes.sm),
//                   child: Center(
//                     child: Text(
//                       service,
//                       style: Theme.of(context)
//                           .textTheme
//                           .labelSmall!
//                           .copyWith(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           )),
//     );
//                     }
//                         ),],
//     );
//   }
// }