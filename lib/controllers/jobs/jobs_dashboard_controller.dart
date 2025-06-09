import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import '../../models/jobs/jobs_dashboard_model.dart';

final providerDashboardProvider = FutureProvider.autoDispose<ProviderDashboard>(
  (ref) async {
    final controller = ref.watch(providerDashboardController);
    return controller.fetchProviderDashboard();
  },
);

final providerDashboardController = Provider(
  (ref) => ProviderDashboardController(),
);

class ProviderDashboardController {
  final storage = const FlutterSecureStorage();
  String jobsDashboardURL =
      dotenv.env['JOBS_DASHBOARD_URL'] ?? 'https://defaulturl.com/api';
  final logger = Logger();

  Future<ProviderDashboard> fetchProviderDashboard() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('No token found');
      final response = await http.get(
        Uri.parse(jobsDashboardURL),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProviderDashboard.fromJson(data);
      } else {
        final exception = 'Failed to load dashboard';
        try {
          await FirebaseCrashlytics.instance.recordError(
            Exception('Failed to load dashboard: ${response.body}'),
            null,
            reason: 'Jobs dashboard API returned error ${response.statusCode}',
          );
        } catch (e) {
          logger.i('Crashlytics jobs dashboard API response failed');
        }
        throw exception;
      }
    } catch (error, stackTrace) {
      try {
        await FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          reason: 'Jobs dashboard controller failed',
        );
      } catch (e) {
        logger.i('Crashlytics jobs dashboard controller failed $e');
      }
      throw Exception('Failed to load dashboard');
    }
  }
}
