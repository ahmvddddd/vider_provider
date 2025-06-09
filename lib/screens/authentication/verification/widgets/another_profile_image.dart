import 'dart:io'show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UploadProfilePage extends StatefulWidget {
  const UploadProfilePage({super.key});

  @override
  UploadProfilePageState createState() => UploadProfilePageState();
}

class UploadProfilePageState extends State<UploadProfilePage> {
  final ImagePicker _picker = ImagePicker();
  final _secureStorage = const FlutterSecureStorage();
  File? _image;

  // Function to pick an image from the device's gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload the image

Future<void> _uploadImage() async {
  if (_image == null) {
     Exception('Please select an image first');
    return;
  }

  try {
    // Check if running on Web
    bool isWeb = kIsWeb;

    // Get the token from secure storage
    String? token;
    if (isWeb) {
      token = await const FlutterSecureStorage().read(key: 'token');
    } else {
      token = await _secureStorage.read(key: 'token');
    }

    if (token == null) {
        Exception('Token not found. Please login again.');
    }

    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/api/uploadimage'),
    );

    // Check if running on Web or Mobile
    if (kIsWeb) {
      List<int> imageBytes = await _image!.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'profileImage',
        imageBytes,
        filename: 'profile_image.png',
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
        'profileImage',
        _image!.path,
      ));
    }

    // Add authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
       Exception('Profile image uploaded successfully');
    } else {
      Exception('Failed to upload image');
    }
  } catch (e) {
     Exception('An error occurred: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Upload Profile Image',
        style: Theme.of(context).textTheme.labelSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(
                _image!,
                height: 200,
              )
            else
              const Placeholder(
                fallbackHeight: 200,
                fallbackWidth: double.infinity,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child:  Text('Select Image from Gallery',
        style: Theme.of(context).textTheme.labelSmall),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child:  Text('Upload Profile Image',
        style: Theme.of(context).textTheme.labelSmall),
            ),
          ],
        ),
      ),
    );
  }
}
