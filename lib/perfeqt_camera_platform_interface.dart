import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'perfeqt_camera_method_channel.dart';

abstract class PerfeqtCameraPlatform extends PlatformInterface {
  /// Constructs a PerfeqtCameraPlatform.
  PerfeqtCameraPlatform() : super(token: _token);

  static final Object _token = Object();

  static PerfeqtCameraPlatform _instance = MethodChannelPerfeqtCamera();

  /// The default instance of [PerfeqtCameraPlatform] to use.
  ///
  /// Defaults to [MethodChannelPerfeqtCamera].
  static PerfeqtCameraPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PerfeqtCameraPlatform] when
  /// they register themselves.
  static set instance(PerfeqtCameraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
