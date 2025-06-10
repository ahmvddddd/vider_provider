import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/messages/chat.dart';
import '../../screens/notifications/notifications.dart';
import '../notifications/message_notification_controller.dart';
import '../notifications/unread_notifications_controller.dart';
import '../../../main.dart';

class NotificationBadgeService {
  final ProviderContainer container;

  NotificationBadgeService({required this.container});

  Future<void> init() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _handleIncomingMessage(message);
    });

    // Use the top-level method instead of inline function
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onNotificationActionTap,
    );
  }

  Future<void> _handleIncomingMessage(RemoteMessage message) async {
    final type = message.data['type'];
    final unreadMsg = container.read(unreadMessageProvider.notifier);
    final unreadNotifs = container.read(unreadNotificationsProvider.notifier);

    if (type == 'chat') {
      unreadMsg.refresh();
    } else if (type == 'notification') {
      unreadNotifs.refresh();
    }

    final totalUnread =
        container.read(unreadMessageProvider).toInt() +
        container.read(unreadNotificationsProvider).toInt();

    await AwesomeNotifications().setGlobalBadgeCounter(totalUnread);
    await _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'basic_channel',
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        notificationLayout: NotificationLayout.Default,
        payload: {'type': message.data['type']},
      ),
    );
  }

  Future<void> updateBadgeCount() async {
    final totalUnread =
        container.read(unreadMessageProvider).toInt() +
        container.read(unreadNotificationsProvider).toInt();

    await AwesomeNotifications().setGlobalBadgeCounter(totalUnread);
  }
}

@pragma("vm:entry-point")
Future<void> onNotificationActionTap(ReceivedAction receivedAction) async {
  final type = receivedAction.payload?['type'];

  if (type == 'chat') {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => ChatScreen()),
    );
  } else if (type == 'notification') {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => NotificationsScreen()),
    );
  }
}
