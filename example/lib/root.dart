import 'package:flutter/material.dart';
import 'package:perfeqt_camera_example/screens/camera_stream_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Perfeqt Camera',
      home: CameraStreamScreen(),
    );
  }
}
