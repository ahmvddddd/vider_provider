import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/widgets/pop_up/custom_snackbar.dart';
import '../../utils/constants/custom_colors.dart';

final transferTokenProvider =
    StateNotifierProvider<TransferTokenController, AsyncValue<void>>(
      (ref) => TransferTokenController(),
    );

class TransferTokenController extends StateNotifier<AsyncValue<void>> {
  TransferTokenController() : super(const AsyncData(null));

  final _storage = const FlutterSecureStorage();
  String transferTokenURL =
      dotenv.env['TRANSFER_TOKEN_URL'] ?? 'https://defaulturl.com/api';

  Future<void> sendToken({
    required BuildContext context,
    required String destinationAddress,
    required String amount,
  }) async {
    state = const AsyncLoading();
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
        CustomSnackbar.show(
          context: context,
          title: 'Success',
          message: 'You tranfer of $amount has been initiated',
          icon: Icons.check_circle,
          backgroundColor: CustomColors.success,
        );
        state = const AsyncData(null);
      } else {
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
