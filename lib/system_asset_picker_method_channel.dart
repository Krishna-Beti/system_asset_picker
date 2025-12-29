import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'system_asset_picker_platform_interface.dart';

/*/// An implementation of [SystemAssetPickerPlatform] that uses method channels.
class MethodChannelSystemAssetPicker extends SystemAssetPickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('system_asset_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}*/


class MethodChannelSystemAssetPicker extends SystemAssetPickerPlatform {
  static const MethodChannel _channel =
  MethodChannel('com.example.system_asset_picker/photo_picker');

  @override
  Future<List<String>> pickImagesAndVideos({
    required int maxItems,
    int maxVideoSizeMB = 100,
  }) async {
    try {
      final List<dynamic> result = await _channel.invokeMethod(
        'pickImagesAndVideos',
        {
          'maxItems': maxItems,
          'maxVideoSizeMB': maxVideoSizeMB,
        },
      );
      return result.cast<String>();
    } on PlatformException catch (e) {
      throw Exception("Failed to pick media: ${e.message}");
    }
  }

  @override
  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      var result = await ImagePicker().pickImage(source: source);
      return result;
    } on PlatformException catch (e) {
      throw Exception("Failed to pick media: ${e.message}");
    }
  }

  @override
  Future<XFile?> pickVideo({ImageSource source = ImageSource.gallery}) async {
    try {
      var result = await ImagePicker().pickVideo(source: source);
      return result;
    } on PlatformException catch (e) {
      throw Exception("Failed to pick media: ${e.message}");
    }
  }

  @override
  Future<List<String>> pickMultipleImages({required int maxItems}) async {
    try {
      final List<dynamic> result = await _channel.invokeMethod(
        'pickImages',
        {'maxItems': maxItems},
      );
      return result.cast<String>();
    } on PlatformException catch (e) {
      throw Exception("Failed to pick images: ${e.message}");
    }
  }

  @override
  Future<List<String>> pickMultipleVideos({required int maxItems, int maxVideoSizeMB = 100,}) async {
    try {
      final List<dynamic> result = await _channel.invokeMethod(
        'pickVideos',
        {
          'maxItems': maxItems,
          'maxVideoSizeMB': maxVideoSizeMB,
        },
      );
      return result.cast<String>();
    } on PlatformException catch (e) {
      throw Exception("Failed to pick videos: ${e.message}");
    }
  }



  @override
  Future<bool> isPhotoPickerAvailable() async {
    try {
      final bool result = await _channel.invokeMethod('isPhotoPickerAvailable');
      return result;
    } catch (e) {
      return false;
    }
  }


}
