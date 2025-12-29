// import 'package:flutter_test/flutter_test.dart';
// import 'package:system_asset_picker/system_asset_picker.dart';
// import 'package:system_asset_picker/system_asset_picker_platform_interface.dart';
// import 'package:system_asset_picker/system_asset_picker_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockSystemAssetPickerPlatform
//     with MockPlatformInterfaceMixin
//     implements SystemAssetPickerPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final SystemAssetPickerPlatform initialPlatform = SystemAssetPickerPlatform.instance;
//
//   test('$MethodChannelSystemAssetPicker is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSystemAssetPicker>());
//   });
//
//   test('getPlatformVersion', () async {
//     SystemAssetPicker systemAssetPickerPlugin = SystemAssetPicker();
//     MockSystemAssetPickerPlatform fakePlatform = MockSystemAssetPickerPlatform();
//     SystemAssetPickerPlatform.instance = fakePlatform;
//
//     expect(await systemAssetPickerPlugin.getPlatformVersion(), '42');
//   });
// }
