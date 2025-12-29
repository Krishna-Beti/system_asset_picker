library system_asset_picker;

import 'package:image_picker/image_picker.dart';

import 'system_asset_picker_platform_interface.dart';

/// A Flutter plugin to pick multiple images and videos using native Android Photo Picker.
///
/// This plugin provides a native gallery UI for selecting multiple images and videos
/// with size restrictions (100MB limit for videos is default, can be changed).
class SystemAssetPicker {

  static Future<List<String>> pickImagesAndVideos({
    required int maxItems,
    int maxVideoSizeMB = 100,
  }) {
    return SystemAssetPickerPlatform.instance.pickImagesAndVideos(
      maxItems: maxItems,
      maxVideoSizeMB: maxVideoSizeMB,
    );
  }

  static Future<bool> isPhotoPickerAvailable() {
    return SystemAssetPickerPlatform.instance.isPhotoPickerAvailable();
  }

  static Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) {
    return SystemAssetPickerPlatform.instance.pickImage(source: source);
  }

  static Future<XFile?> pickVideo({ImageSource source = ImageSource.gallery}) {
    return SystemAssetPickerPlatform.instance.pickVideo(source: source);
  }

  static Future<List<String>> pickMultipleImages({required int maxItems}) {
    return SystemAssetPickerPlatform.instance.pickMultipleImages(maxItems: maxItems);
  }

  static Future<List<String>> pickMultipleVideos({required int maxItems, int maxVideoSizeMB = 100,}) {
    return SystemAssetPickerPlatform.instance.pickMultipleVideos(maxItems: maxItems);
  }

}
