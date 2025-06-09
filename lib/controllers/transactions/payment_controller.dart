import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

final paymentProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((
      ref,
      payload,
    ) async {
      final logger = Logger();
      String createPaymentURL =
          dotenv.env['CREATE_PAYMENT_URL'] ?? 'https://defaulturl.com/api';

      try {
        final response = await http.post(
          Uri.parse(createPaymentURL),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          final exception = 'Payment failed';
          try {
            await FirebaseCrashlytics.instance.recordError(
              Exception("Failed to make payment: ${response.body}"),
              null,
              reason: 'Payment API returned error ${response.statusCode}',
            );
          } catch (e) {
            logger.i('Crashlytics payment API response failed');
          }
          throw exception;
        }
      } catch (error, stackTrace) {
        try {
          await FirebaseCrashlytics.instance.recordError(
            error,
            stackTrace,
            reason: 'Payment controller failed',
          );
        } catch (e) {
          logger.i('Crashlytics payment controller failed $e');
        }
        throw Exception('Payment failed');
      }
    });

final currenciesProvider = FutureProvider<List<String>>((ref) async {
  final logger = Logger();
  String fetchCurrenciesURL =
      dotenv.env['FETCH_CURRENCIES_URL'] ?? 'https://defaulturl.com/api';
  try {
    final response = await http.get(Uri.parse(fetchCurrenciesURL));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['selectedCurrencies'] ?? []);
    } else {
      final exception = 'Failed to fetch currencies';
      try {
        await FirebaseCrashlytics.instance.recordError(
          Exception("Failed to fetch currencies: ${response.body}"),
          null,
          reason: 'Fetch currencies API returned error ${response.statusCode}',
        );
      } catch (e) {
        logger.i('Crashlytics fetch currencies API response failed');
      }
      throw exception;
    }
  } catch (error, stackTrace) {
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Payment controller failed',
      );
    } catch (e) {
      logger.i('Crashlytics payment controller failed $e');
    }
    throw Exception('Failed to fetch currencies');
  }
});
