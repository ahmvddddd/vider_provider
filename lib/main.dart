import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await dotenv.load(fileName: ".env");

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Initialize awesome notifications
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ],
    debug: true,
  );

  // Request permissions
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  // Firebase background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


      runApp(const ProviderScope(child: App()));
    },
    (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Uncaught async error',
        fatal: true,
      );
    },
  );
}

// Must be a top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Display only minimal notification for background mode
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      channelKey: 'basic_channel',
      title: message.notification?.title ?? message.data['title'] ?? 'New Notification',
      body: message.notification?.body ?? message.data['body'] ?? '',
      notificationLayout: NotificationLayout.Default,
      payload: {
        'type': message.data['type'] ?? '',
        // You can pass extra info here for use when the app resumes
      },
    ),
  );
}