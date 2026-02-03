import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import '../config/cloudinary_config.dart';

/// Service for handling image uploads to Cloudinary
class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  late final CloudinaryPublic _cloudinary;
  bool _isInitialized = false;

  /// Initialize Cloudinary
  void initialize() {
    if (_isInitialized) return;

    _cloudinary = CloudinaryPublic(
      CloudinaryConfig.cloudName,
      CloudinaryConfig.uploadPreset,
      cache: false,
    );

    _isInitialized = true;
    debugPrint('✅ Cloudinary initialized');
  }

  /// Upload plant image
  Future<String?> uploadPlantImage(File imageFile) async {
    try {
      if (!_isInitialized) initialize();

      debugPrint('📤 Uploading plant image to Cloudinary...');

      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: CloudinaryConfig.plantsFolder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      debugPrint('✅ Image uploaded successfully: ${response.secureUrl}');
      return response.secureUrl;
    } catch (e) {
      debugPrint('❌ Error uploading plant image: $e');
      return null;
    }
  }

  /// Upload profile image
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      if (!_isInitialized) initialize();

      debugPrint('📤 Uploading profile image to Cloudinary...');

      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: CloudinaryConfig.profilesFolder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      debugPrint('✅ Profile image uploaded: ${response.secureUrl}');
      return response.secureUrl;
    } catch (e) {
      debugPrint('❌ Error uploading profile image: $e');
      return null;
    }
  }

  /// Get optimized image URL with transformations
  String getOptimizedImageUrl(
    String imageUrl, {
    int? width,
    int? height,
    String quality = 'auto',
    String format = 'auto',
  }) {
    if (!imageUrl.contains('cloudinary')) {
      // Not a Cloudinary URL, return as is
      return imageUrl;
    }

    // Build transformation string
    final transformations = <String>[];
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('q_$quality');
    transformations.add('f_$format');

    final transformString = transformations.join(',');

    // Insert transformations into Cloudinary URL
    return imageUrl.replaceFirst('/upload/', '/upload/$transformString/');
  }

  /// Get thumbnail URL (200x200)
  String getThumbnailUrl(String imageUrl) {
    return getOptimizedImageUrl(
      imageUrl,
      width: 200,
      height: 200,
    );
  }

  /// Get medium size URL (800x800)
  String getMediumUrl(String imageUrl) {
    return getOptimizedImageUrl(
      imageUrl,
      width: 800,
      height: 800,
    );
  }
}