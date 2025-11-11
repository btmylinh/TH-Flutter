import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class CloudinaryService {
  static const String cloudName = 'diml6g3k2';
  static const String apiKey = '838956647376271';
  static const String apiSecret = 'IV7P2tjszr-6iFQRNFJUlkInS3k';

  /// Upload ảnh lên Cloudinary với signed upload
  /// Returns: URL của ảnh đã upload
  static Future<String> uploadImage(File imageFile) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final folder = 'restaurant_reviews';

      // Tạo signature
      final stringToSign = 'folder=$folder&timestamp=$timestamp$apiSecret';
      final signature = sha1.convert(utf8.encode(stringToSign)).toString();

      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', url);

      // Thêm file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Thêm parameters
      request.fields['api_key'] = apiKey;
      request.fields['timestamp'] = timestamp;
      request.fields['signature'] = signature;
      request.fields['folder'] = folder;

      // Gửi request
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseString);
        return jsonResponse['secure_url'] as String;
      } else {
        throw Exception('Failed to upload image: $responseString');
      }
    } catch (e) {
      throw Exception('Error uploading to Cloudinary: $e');
    }
  }

  /// Upload nhiều ảnh
  static Future<List<String>> uploadMultipleImages(List<File> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      try {
        final url = await uploadImage(image);
        imageUrls.add(url);
      } catch (e) {
        print('Error uploading image: $e');
        // Có thể continue hoặc throw tùy yêu cầu
      }
    }

    return imageUrls;
  }
}
