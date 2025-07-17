import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../../common/widgets/pop_up/custom_snackbar.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/helpers/connectivity_helper.dart';
import '../../utils/helpers/helper_function.dart';
import '../../utils/helpers/success_screen.dart';

final transferTokenProvider =
    StateNotifierProvider<TransferTokenController, AsyncValue<void>>(
      (ref) => TransferTokenController(),
    );

class TransferTokenController extends StateNotifier<AsyncValue<void>> {
  TransferTokenController() : super(const AsyncData(null));

  final _storage = const FlutterSecureStorage();
  String transferTokenURL =
      dotenv.env['TRANSFER_TOKEN_URL'] ?? 'https://defaulturl.com/api';
  final logger = Logger();

  Future<void> sendToken({
    required BuildContext context,
    required String destinationAddress,
    required String amount,
    required WidgetRef ref,
  }) async {
    state = const AsyncLoading();

    final connectivity = ref.read(connectivityProvider);

    if (!connectivity.isOnline) {
      CustomSnackbar.show(
        context: context,
        title: 'No Internet',
        message: 'Please check your internet connection',
        icon: Icons.wifi_off,
        backgroundColor: CustomColors.error,
      );
      state = const AsyncData(null);
      return;
    }
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.post(
        Uri.parse(transferTokenURL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'destinationAddress': destinationAddress,
          'amount': amount,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        HelperFunction.navigateScreen(
          context,
          SuccessScreen(
            title: 'Transfer Successful',
            subtitle: 'Your transfer of $amount USDC has been initiated.',
          ),
        );
        state = const AsyncData(null);
      } else {
        try {
          await FirebaseCrashlytics.instance.recordError(
            Exception("Failed to transfer token: ${response.body}"),
            null,
            reason:
                'Fetch transfer token API returned error ${response.statusCode}',
          );
        } catch (e) {
          logger.i('Crashlytics transfer token API response failed');
        }
        CustomSnackbar.show(
          context: context,
          title: 'Error',
          message: 'Transaction failed',
          icon: Icons.error_outline,
          backgroundColor: CustomColors.error,
        );
        debugPrint(response.body);
        throw Exception(body['message'] ?? 'Transfer failed');
      }
    } catch (e, st) {
      try {
        await FirebaseCrashlytics.instance.recordError(
          e,
          st,
          reason: 'Fetch transfer token controller failed',
        );
      } catch (e) {
        logger.i('Crashlytics transfer token controller failed $e');
      }
      CustomSnackbar.show(
        context: context,
        title: 'Error',
        message: 'An error occured',
        icon: Icons.error_outline,
        backgroundColor: CustomColors.error,
      );
      debugPrint(e.toString());
      state = AsyncError(e, st);
    }
  }
}
