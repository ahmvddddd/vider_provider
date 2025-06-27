// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../notifications/message_notification_controller.dart';
// import '../notifications/unread_notifications_controller.dart';

// /// 🔔 Handle notification tap from local (Awesome Notifications)
// @pragma("vm:entry-point")
// Future<void> onNotificationActionTap(ReceivedAction receivedAction) async {
//   debugPrint('🟦 Notification tapped via Awesome Notifications: ${receivedAction.payload}');
// }

// /// 🛠️ Background message handler for FCM
// @pragma("vm:entry-point")
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   debugPrint('🟪 Background FCM message received: ${message.messageId}');

//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       channelKey: 'basic_channel',
//       title: message.notification?.title ?? 'New Notification',
//       body: message.notification?.body ?? '',
//       notificationLayout: NotificationLayout.Default,
//       payload: {
//         'type': message.data['type'] ?? '',
//       },
//     ),
//   );
// }

// /// 🔄 Notification Badge + Push Handler Service
// class NotificationBadgeService {
//   final ProviderContainer container;

//   NotificationBadgeService({required this.container});

//   Future<void> init() async {
//     // 🔴 Foreground FCM messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       debugPrint("🟥 Foreground FCM received: ${message.messageId}");
//       await _handleIncomingMessage(message);
//     });

//     // 🟧 App opened from FCM notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       debugPrint('🟧 FCM Tap - App Opened: ${message.data}');
//       await _handleIncomingMessage(message); // optional: refresh state
//     });

//     // 🟩 Local notification tap (Awesome Notifications)
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onNotificationActionTap,
//     );

//     // 🟨 Register background FCM handler
//     // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   /// 📦 Handle foreground or tapped message
//   Future<void> _handleIncomingMessage(RemoteMessage message) async {
//     final type = message.data['type'];
//     final unreadMsg = container.read(unreadMessageProvider.notifier);
//     final unreadNotifs = container.read(unreadNotificationsProvider.notifier);

//     if (type == 'chat') {
//       unreadMsg.refresh();
//     } else if (type == 'notification' || type == 'generic') {
//       unreadNotifs.refresh();
//     }

//     final totalUnread =
//         container.read(unreadMessageProvider).toInt() +
//         container.read(unreadNotificationsProvider).toInt();

//     await AwesomeNotifications().setGlobalBadgeCounter(totalUnread);
//     await showLocalNotification(message);
//   }

//   /// 🔔 Show local notification via Awesome Notifications
//   Future<void> showLocalNotification(RemoteMessage message) async {
//     debugPrint("🔔 Showing Awesome Notification: ${message.notification?.title}");

//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         channelKey: 'basic_channel',
//         title: message.notification?.title ?? 'New Notification',
//         body: message.notification?.body ?? '',
//         notificationLayout: NotificationLayout.Default,
//         payload: {
//           'type': message.data['type'] ?? '',
//         },
//       ),
//     );
//   }

//   /// 🔄 Recalculate global badge counter
//   Future<void> updateBadgeCount() async {
//     final totalUnread =
//         container.read(unreadMessageProvider).toInt() +
//         container.read(unreadNotificationsProvider).toInt();

//     await AwesomeNotifications().setGlobalBadgeCounter(totalUnread);
//   }
// }



// lib/controllers/services/notification_badge_service.dart

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifications/unread_notifications_controller.dart';
import '../notifications/message_notification_controller.dart';
import 'notification_listeners.dart'; // ✅ Import the global handler

class NotificationBadgeService {
  final ProviderContainer container;

  NotificationBadgeService({required this.container});

  Future<void> init() async {
    // Foreground FCM
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("🟥 Foreground FCM received: ${message.messageId}");
      await _handleIncomingMessage(message);
    });

    // Tapped FCM
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('🟧 FCM Tap - App Opened: ${message.data}');
      await _handleIncomingMessage(message);
    });

    // Register top-level listener for notification taps
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onNotificationActionTap, // ✅ GLOBAL TOP-LEVEL
    );
  }

  Future<void> _handleIncomingMessage(RemoteMessage message) async {
    final type = message.data['type'];
    final unreadMsg = container.read(unreadMessageProvider.notifier);
    final unreadNotifs = container.read(unreadNotificationsProvider.notifier);

    if (type == 'chat') {
      unreadMsg.refresh();
    } else {
      unreadNotifs.refresh();
    }

    final  int totalUnread = container.read(unreadMessageProvider) +
        container.read(unreadNotificationsProvider);

    await AwesomeNotifications().setGlobalBadgeCounter(totalUnread);
  }

  Future<void> updateBadgeCount() async {
    final int totalUnread = container.read(unreadMessageProvider) +
        container.read(unreadNotificationsProvider);

    await AwesomeNotifications().setGlobalBadgeCounter(totalUnread);
  }
}
