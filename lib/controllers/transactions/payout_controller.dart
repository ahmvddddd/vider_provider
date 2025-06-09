import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

final payoutProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  payload,
) async {
  final logger = Logger();
  String sendPayoutURL =
      dotenv.env['SEND_PAYOUT_URL'] ?? 'https://defaulturl.com/api';

  try {
    final response = await http.post(
      Uri.parse(sendPayoutURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      final exception = 'Failed to send payout';
      try {
        await FirebaseCrashlytics.instance.recordError(
          Exception("Failed to create payout: ${response.body}"),
          null,
          reason: 'Payout API returned error ${response.statusCode}',
        );
      } catch (e) {
        logger.i('Crashlytics payout API response failed');
      }
      throw exception;
    }
  } catch (error, stackTrace) {
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Payout controller failed',
      );
    } catch (e) {
      logger.i('Crashlytics payout controller failed $e');
    }
    throw Exception('Failed to send payout');
  }
});
