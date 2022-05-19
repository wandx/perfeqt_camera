import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perfeqt_camera/perfeqt_camera_method_channel.dart';

void main() {
  MethodChannelPerfeqtCamera platform = MethodChannelPerfeqtCamera();
  const MethodChannel channel = MethodChannel('perfeqt_camera');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
