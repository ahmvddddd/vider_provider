// import 'dart:io';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../common/widgets/pop_up/custom_snackbar.dart';
import '../../screens/authentication/user_details/upload_id_screen.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/helpers/helper_function.dart';

final portfolioUploadControllerProvider =
    StateNotifierProvider<PortfolioUploadController, AsyncValue<List<String>>>(
      (ref) => PortfolioUploadController(),
    );

class PortfolioUploadController
    extends StateNotifier<AsyncValue<List<String>>> {
  PortfolioUploadController() : super(const AsyncValue.data([]));
  String uploadPortfolioImagesURL =
      dotenv.env['UPLOAD_PORTFOLIO_IMAGES_URL'] ?? 'https://defaulturl.com/api';

  final Dio _dio = Dio();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> uploadImages(BuildContext context, List<File> images) async {
    state = const AsyncValue.loading();

    try {
      final token = await storage.read(
        key: 'token',
      ); // Await here to get the token

      final formData = FormData();

      for (int i = 0; i < images.length && i < 4; i++) {
        formData.files.add(
          MapEntry(
            'portfolioImages',
            await MultipartFile.fromFile(
              images[i].path,
              filename: 'image$i.jpg',
            ),
          ),
        );
      }

      final response = await _dio.post(
        uploadPortfolioImagesURL,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> urls = response.data['portfolioImages'];
        state = AsyncValue.data(List<String>.from(urls));

        CustomSnackbar.show(
          context: context,
          title: 'Success',
          message: 'Uploaded portfolio images successfully',
          icon: Icons.check_circle,
          backgroundColor: CustomColors.success,
        );
        HelperFunction.navigateScreen(context, UploadIdScreen());
      } else {
        await FirebaseCrashlytics.instance.recordError(
          Exception(
            "Failed to upload portfolio images: ${response.statusCode}",
          ),
          null,
          reason:
              'Upload portfolio images API returned error ${response.statusCode}',
        );

        CustomSnackbar.show(
          context: context,
          title: 'An error occurred. ',
          message: 'Failed to upload portfolio images',
          icon: Icons.error_outline,
          backgroundColor: CustomColors.error,
        );
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error('Failed to upload portfolio images', stackTrace);

      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Upload portfolio images controller failed',
      );

      CustomSnackbar.show(
        context: context,
        title: 'An error occurred',
        message: 'Failed to upload portfolio images',
        icon: Icons.error_outline,
        backgroundColor: CustomColors.error,
      );
    }
  }
}

final userPortfolioUpdateProvider = FutureProvider.family<void, Map<int, File>>((ref, filesWithIndexes) async {
  const storage = FlutterSecureStorage();
  final logger = Logger();
  String updatePortfolioImagesURL = dotenv.env['UPDATE_PORTFOLIO_IMAGES_URL'] ?? 'https://defaulturl.com/api';

  try {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception("An error occurred");

    final uri = Uri.parse(updatePortfolioImagesURL);
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token';

    for (final entry in filesWithIndexes.entries) {
      final index = entry.key;
      final file = entry.value;

      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      final multipartFile = await http.MultipartFile.fromPath(
        'images', // should match the backend field name
        file.path,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      // Add each index as a separate field (if your backend supports it)
      request.fields['indexes[$index]'] = index.toString();
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      final exception = 'Failed to update portfolio images';
      try {
        await FirebaseCrashlytics.instance.recordError(
          Exception("Failed to update portfolio images: ${response.statusCode}"),
          null,
          reason: 'Update portfolio images API returned error ${response.statusCode}',
        );
      } catch (e) {
        logger.i('Crashlytics update portfolio images API response failed');
      }
      throw Exception(exception);
    }
  } catch (error, stackTrace) {
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Upload portfolio images controller failed',
      );
    } catch (e) {
      logger.i('Crashlytics update portfolio images controller failed $e');
    }
    throw Exception('Failed to update portfolio images');
  }
});
