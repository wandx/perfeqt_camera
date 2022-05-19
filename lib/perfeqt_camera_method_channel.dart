import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'perfeqt_camera_platform_interface.dart';

/// An implementation of [PerfeqtCameraPlatform] that uses method channels.
class MethodChannelPerfeqtCamera extends PerfeqtCameraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('perfeqt_camera');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
