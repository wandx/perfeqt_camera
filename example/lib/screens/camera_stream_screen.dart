import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';
import 'package:perfeqt_camera/perfeqt_camera.dart';
import 'package:perfeqt_camera_example/screens/anchor_layer.dart';
import 'package:perfeqt_camera_example/screens/edge_layer.dart';
import 'package:velocity_x/velocity_x.dart';

class CameraStreamScreen extends StatefulWidget {
  const CameraStreamScreen({Key? key}) : super(key: key);

  @override
  State<CameraStreamScreen> createState() => _CameraStreamScreenState();
}

class _CameraStreamScreenState extends State<CameraStreamScreen> {
  final _aspectRationKey = GlobalKey();

  CameraController? _cameraController;
  EdgeDetectionResult? _edgeDetectionResult;

  bool _processing = false;
  double _boxWidth = 0;
  double _boxHeight = 0;

  @override
  initState() {
    super.initState();
    _initCamera();
  }

  // initialize camera
  void _initCamera() {
    availableCameras().then((cameras) {
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.veryHigh,
      );
      return _cameraController!.initialize();
    }).then((_) {
      if (mounted) {
        _cameraController!.lockCaptureOrientation(DeviceOrientation.portraitUp);
        _cameraController!.startImageStream((image) => _scanCamera(image));
      }
    });
  }

  // camera stream listener
  void _scanCamera(CameraImage availableImage) async {
    if (_processing) {
      return;
    }

    setState(() => _processing = true);

    log('Box Size: w = $_boxWidth, h = $_boxHeight');
    log('OriginalSize: w = ${_cameraController!.value.previewSize!.width}, h = ${_cameraController!.value.previewSize!.height}');
    log('RenderSize: w = ${availableImage.width}, h = ${availableImage.height}');

    if (_aspectRationKey.currentContext != null) {
      final box = _aspectRationKey.currentContext!.findRenderObject();
      final renderBox = box as RenderBox;
      setState(() {
        _boxWidth = renderBox.size.width;
        _boxHeight = renderBox.size.height;
      });
    }

    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      setState(() => _processing = false);
    });

    await ImageStreamConverter.convertImageToPng(availableImage)
        .then((path) async {
      await PerfeqtCamera.detectEdges(path!).then((result) {
        setState(() => _edgeDetectionResult = result);
      }).whenComplete(() async {
        await deleteImage(path);
      });
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        setState(() => _processing = false);
      });
    });
  }

  // delete image
  Future<void> deleteImage(String path) async {
    final file = File(path);
    await file.delete();
    log('Deleted: $path');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        if (!mounted || _cameraController == null) {
          return Container();
        }
        return ZStack([
          AspectRatio(
            key: _aspectRationKey,
            aspectRatio: _cameraController!.value.previewSize!.height /
                _cameraController!.value.previewSize!.width,
            child: CameraPreview(_cameraController!),
          ),
          Builder(builder: (context) {
            if (_edgeDetectionResult == null) {
              return const SizedBox();
            }

            var w = _cameraController!.value.previewSize?.width ?? 0;
            var h = _cameraController!.value.previewSize?.height ?? 0;

            if (w > h) {
              var newWidth = h;
              var newHeight = w;
              w = newWidth;
              h = newHeight;
            }

            return EdgeLayer(
              renderedImageSize: Size(
                _boxWidth,
                _boxHeight,
              ),
              originalImageSize: Size(w, h),
              edgeDetectionResult: _edgeDetectionResult,
            );
          }),
          Builder(builder: (context) {
            return AnchorLayer(boxSize: Size(_boxWidth,_boxHeight));
          }),
        ]);
      }),
    );
  }
}

class ImageStreamConverter {
  static imglib.Image convertBGRA8888(CameraImage image) {
    return imglib.Image.fromBytes(
      image.width,
      image.height,
      image.planes[0].bytes,
      format: imglib.Format.bgra,
    );
  }

  static Future<String?> convertYUV420toImageColor(CameraImage image) async {
    try {
      var img = imglib.Image(image.width, image.height); // Create Image buffer

      Plane plane = image.planes[0];
      const int shift = (0xFF << 24);

      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < image.width; x++) {
        for (int planeOffset = 0;
            planeOffset < image.height * image.width;
            planeOffset += image.width) {
          final pixelColor = plane.bytes[planeOffset + x];
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          // Calculate pixel color
          var newVal =
              shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

          img.data[planeOffset + x] = newVal;
        }
      }

      final originalImage = img;
      final height1 = originalImage.height;
      final width1 = originalImage.width;

      if (height1 < width1) {
        img = imglib.copyRotate(originalImage, 90);
      }

      final extDir = await getTemporaryDirectory();
      final dirPath = '${extDir.path}/streams/images';
      await Directory(dirPath).create(recursive: true);

      final filePath = '$dirPath/${DateTime.now().millisecondsSinceEpoch}.png';

      await File(filePath).writeAsBytes(imglib.encodeJpg(img));

      return filePath;
    } catch (e) {
      log('>>>>>>>>>>>> ERROR:$e');
    }
    return null;
  }

  static Future<String?> convertImageToPng(CameraImage image) async {
    late String path;
    try {
      imglib.Image img;
      if (image.format.group == ImageFormatGroup.yuv420) {
        final filePath = await convertYUV420toImageColor(image);
        path = filePath!;
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        img = convertBGRA8888(image);
        imglib.PngEncoder pngEncoder = imglib.PngEncoder();
        final extDir = await getTemporaryDirectory();
        final dirPath = '${extDir.path}/streams/images';
        await Directory(dirPath).create(recursive: true);

        final filePath =
            '$dirPath/${DateTime.now().millisecondsSinceEpoch}.png';

        await File(filePath).writeAsBytes(pngEncoder.encodeImage(img));

        path = filePath;
      }
      return path;
    } catch (e) {
      log('>>>>>>>>>>>> ERROR:$e');
    }
    return null;
  }
}
