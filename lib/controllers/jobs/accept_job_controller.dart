import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import '../../common/widgets/pop_up/custom_snackbar.dart';
import '../../utils/constants/custom_colors.dart';

// StateNotifier to manage job creation state
final addJobControllerProvider =
    StateNotifierProvider<AddJobController, AsyncValue<void>>(
      (ref) => AddJobController(),
    );

class AddJobController extends StateNotifier<AsyncValue<void>> {
  AddJobController() : super(const AsyncValue.data(null));

  String addJobURL = dotenv.env['ADD_JOB_URL'] ?? 'https://defaulturl.com/api';
  final logger = Logger();

  Future<void> addJob({
    required BuildContext context,
    required String employerId,
    required String providerId,
    required String employerImage,
    required String providerImage,
    required String employerName,
    required String providerName,
    required String jobTitle,
    required double pay,
    required int duration,
  }) async {
    state = const AsyncValue.loading();

    try {
      final url = Uri.parse(addJobURL);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'employerId': employerId,
          'providerId': providerId,
          'employerImage': employerImage,
          'providerImage': providerImage,
          'employerName': employerName,
          'providerName': providerName,
          'jobTitle': jobTitle,
          'pay': pay,
          'duration': duration,
        }),
      );

      if (response.statusCode == 201) {
        state = const AsyncValue.data(null);
        CustomSnackbar.show(
          context: context,
          title: 'Job request accepted',
          message: 'The countdown has started',
          backgroundColor: CustomColors.success,
          icon: Icons.check_circle,
        );
      } else {
        print(response.body);
        CustomSnackbar.show(
          context: context,
          title: 'An error occurred',
          message: 'Could not accept job request. Try again later',
          backgroundColor: CustomColors.error,
          icon: Icons.cancel,
        );
        final exception = 'Failed to accept job offer';
        try {
          await FirebaseCrashlytics.instance.recordError(
            Exception("Failed to accept job offer: ${response.body}"),
            null,
            reason: 'Accept job API returned error ${response.statusCode}',
          );
        } catch (e) {
          logger.i('Crashlytics accept job API response failed');
        }
        throw exception;
      }
    } catch (error, stackTrace) {
      print(error.toString());
      CustomSnackbar.show(
        context: context,
        title: 'An error occurred',
        message: 'Could not accept job request. Try again later',
        backgroundColor: CustomColors.error,
        icon: Icons.cancel,
      );
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Delete notifications controller failed',
      );
      state = AsyncValue.error('Could not accept job request', stackTrace);
    }
  }
}
