import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:system_asset_picker/system_asset_picker_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSystemAssetPicker platform = MethodChannelSystemAssetPicker();
  const MethodChannel channel = MethodChannel('system_asset_picker');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await platform.getPlatformVersion(), '42');
  // });
}
