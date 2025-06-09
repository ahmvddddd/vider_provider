// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../controllers/notifications/message_notification_controller.dart';
// import '../../../../utils/constants/sizes.dart';

// class IconContainer extends ConsumerStatefulWidget {
//   const IconContainer({
//     super.key,
//   });

//   @override
//   ConsumerState<IconContainer> createState() => _IconContainerState();
// }

// class _IconContainerState extends ConsumerState<IconContainer> {
//   @override
//   Widget build(BuildContext context) {
//     final messageController = ref.watch(messageNotificationProvider);
//     return Stack(
//       children: [
//         const Icon(Iconsax.message,
//         size: Sizes.iconMd),
//         Positioned(
//             right: -0.3,
//             top: -0.3,
//           child:
//             messageController.unreadCount! > 0 ? 
//               Container(
//               width: 15,
//               height: 15,
//               padding: const EdgeInsets.all(1),
//                 decoration: BoxDecoration(
//                   color: Colors.red[900],
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     '${messageController.unreadCount}',
//                     style: Theme.of(context)
//                         .textTheme
//                         .labelSmall!
//                         .copyWith(color: Colors.white, fontSize: 8),
//                   ),
//                 ),
//               ) 
//              : const SizedBox()
//         ),
//       ],
//     );
//   }
// }