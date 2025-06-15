// signout_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../screens/authentication/auth_screen.dart';
import '../../utils/helpers/helper_function.dart';

final signoutControllerProvider =
    StateNotifierProvider<SignoutController, SignoutState>((ref) {
      return SignoutController();
    });

class SignoutController extends StateNotifier<SignoutState> {
  SignoutController() : super(SignoutState());

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> signOut(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      // Delete token from secure storage
      await _secureStorage.delete(key: 'token');

      // Remove saved username from shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_username');

      state = state.copyWith(isLoading: false);

      // Navigate to login screen (or any auth screen)
      HelperFunction.navigateScreenReplacement(
        context,
        const AuthScreen(),
      ); // Replace with your actual signin screen
    } catch (error, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to sign out. Please try again.',
      );
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Sign out controller failed',
      );
    }
  }
}

class SignoutState {
  final bool isLoading;
  final String? error;

  SignoutState({this.isLoading = false, this.error});

  SignoutState copyWith({bool? isLoading, String? error}) {
    return SignoutState(isLoading: isLoading ?? this.isLoading, error: error);
  }
}
