import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final jobVerifyProvider =
    FutureProvider.family.autoDispose<bool, Map<String, String>>((ref, payload) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'authToken');
  String jobVerificationURL = dotenv.env['JOB_VERIFICATION_URL'] ?? "https://defaulturl.com/api";

  final response = await http.post(
    Uri.parse(jobVerificationURL),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Verification failed");
  }
});
