import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../../nav_menu.dart';
import '../../models/user/user_model.dart';
import '../../repository/user/username_local_storage.dart';
import '../../utils/helpers/helper_function.dart';
import '../services/firebase_service.dart';
import '../user/user_controller.dart'; // Import UserController

// Secure storage instance
const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

// Provider
final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
      return LoginController(ref);
    });

// Controller
class LoginController extends StateNotifier<LoginState> {
  final Ref ref;
  final String signinUrl =
      dotenv.env['SIGNIN_URL'] ?? 'https://defaulturl.com/api';

  LoginController(this.ref) : super(LoginState());

  String formatBackendError(String message) {
    if (message.contains('Invalid username or password')) {
      return 'Your login details are incorrect.';
    } else if (message.contains('Account locked. Try again in 15 minutes.')) {
      return 'Account locked. Try again in 15 minutes.';
    } else {
      return message;
    }
  }

  Future<void> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await http.post(
        Uri.parse(signinUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final user = User(
          username: responseData['username'],
          password: responseData['password'],
        );

        // Save the token
        await _secureStorage.write(key: 'token', value: responseData['token']);

        // Save username
        await UsernameLocalStorage.saveUsername(username);

        // Fetch user profile via UserController
        await ref.read(userProvider.notifier).fetchUserDetails();

        // Optional: Register FCM
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          saveFcmTokenToBackend();
        });

        state = state.copyWith(isLoading: false, user: user);

        // Navigate to the main screen
        HelperFunction.navigateScreenReplacement(context, NavigationMenu());
      } else {
        final responseData = jsonDecode(response.body);
        final rawError = responseData['message'] ?? 'Signin failed';
        final formattedError =
            response.statusCode == 500
                ? 'Something went wrong on our side. Please try again later.'
                : formatBackendError(rawError);

        state = state.copyWith(isLoading: false, error: formattedError);
        await FirebaseCrashlytics.instance.recordError(
          Exception("Login failed: $formattedError"),
          null,
          reason: 'Login API error ${response.statusCode}',
        );
      }
    } catch (error, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: "An error occurred. Please try again later.",
      );
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Login controller error',
      );
    }
  }
}
