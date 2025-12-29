import 'package:image_picker/image_picker.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'system_asset_picker_method_channel.dart';

/*abstract class SystemAssetPickerPlatform extends PlatformInterface {
  /// Constructs a SystemAssetPickerPlatform.
  SystemAssetPickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static SystemAssetPickerPlatform _instance = MethodChannelSystemAssetPicker();

  /// The default instance of [SystemAssetPickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelSystemAssetPicker].
  static SystemAssetPickerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SystemAssetPickerPlatform] when
  /// they register themselves.
  static set instance(SystemAssetPickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}*/


abstract class SystemAssetPickerPlatform extends PlatformInterface {
  SystemAssetPickerPlatform() : super(token: _token);

  static final Object _token = Object();
  static SystemAssetPickerPlatform _instance = MethodChannelSystemAssetPicker();

  static SystemAssetPickerPlatform get instance => _instance;

  static set instance(SystemAssetPickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Pick multiple images and videos
  Future<List<String>> pickImagesAndVideos({required int maxItems, required int maxVideoSizeMB}) {
    throw UnimplementedError('pickMedia() has not been implemented.');
  }


  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery,}) {
    throw UnimplementedError('pickMedia() has not been implemented.');
  }

  Future<List<String>> pickMultipleImages({required int maxItems}) {
    throw UnimplementedError('pickMultipleImages() has not been implemented.');
  }

  Future<XFile?> pickVideo({ImageSource source = ImageSource.gallery,}) {
    throw UnimplementedError('pickVideo() has not been implemented.');
  }

  Future<List<String>> pickMultipleVideos({required int maxItems, int maxVideoSizeMB = 100,} ) {
    throw UnimplementedError('pickMultipleVideos() has not been implemented.');
  }

  /// Check if Photo Picker is available
  Future<bool> isPhotoPickerAvailable() {
    throw UnimplementedError('isPhotoPickerAvailable() has not been implemented.');
  }



}
