import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  static final CloudinaryService instance = CloudinaryService._();
  CloudinaryService._();

  // Thông tin Cloudinary
  final String _cloudName = 'diml6g3k2';
  final String _uploadPreset = 'gym_manager';

  late final CloudinaryPublic _cloudinary;

  void initialize() {
    _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);
  }

  /// Upload ảnh lên Cloudinary
  /// [file] - File ảnh cần upload
  /// [folder] - Thư mục trên Cloudinary (VD: 'restaurants', 'reviews')
  /// Returns URL của ảnh đã upload
  Future<String> uploadImage(File file, String folder) async {
    try {
      print('📤 Cloudinary: Đang upload file ${file.path} vào folder $folder');

      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: folder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      print('✅ Cloudinary: Upload thành công!');
      print('   - Public ID: ${response.publicId}');
      print('   - Secure URL: ${response.secureUrl}');

      return response.secureUrl;
    } catch (e) {
      print('❌ Cloudinary: Upload thất bại - ${e.toString()}');
      throw Exception('Upload ảnh thất bại: ${e.toString()}');
    }
  }

  /// Upload nhiều ảnh cùng lúc
  /// Returns danh sách URLs
  Future<List<String>> uploadMultipleImages(
    List<File> files,
    String folder,
  ) async {
    try {
      final List<String> urls = [];
      for (final file in files) {
        final url = await uploadImage(file, folder);
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw Exception('Upload nhiều ảnh thất bại: ${e.toString()}');
    }
  }

  /// Xóa ảnh từ Cloudinary (optional - cần API key và secret)
  /// Cloudinary free tier không hỗ trợ delete qua SDK
  /// Phải dùng Admin API hoặc xóa manual trên console
  Future<void> deleteImage(String publicId) async {
    // Cần implement với Admin API nếu cần
    // Hiện tại để trống vì cần API key và secret (không nên expose ở client)
    throw UnimplementedError(
      'Delete chỉ nên thực hiện từ server (Cloud Functions)',
    );
  }
}
