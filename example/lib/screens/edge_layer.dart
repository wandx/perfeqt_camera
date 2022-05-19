import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perfeqt_camera/perfeqt_camera.dart';

import 'edge_detection_shape/edge_painter.dart';

class EdgeLayer extends StatefulWidget {
  const EdgeLayer({
    Key? key,
    required this.renderedImageSize,
    required this.originalImageSize,
    required this.edgeDetectionResult,
  }) : super(key: key);

  final Size renderedImageSize;
  final Size originalImageSize;
  final EdgeDetectionResult? edgeDetectionResult;

  @override
  State<EdgeLayer> createState() => _EdgeLayerState();
}

class _EdgeLayerState extends State<EdgeLayer> {
  List<Offset> points = [];
  EdgeDetectionResult? edgeDetectionResult;

  late double renderedImageWidth;
  late double renderedImageHeight;
  late double top;
  late double left;

  @override
  initState() {
    edgeDetectionResult = widget.edgeDetectionResult;
    _updatePoints();
    super.initState();
  }

  @override
  didUpdateWidget(EdgeLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.edgeDetectionResult != widget.edgeDetectionResult) {
      edgeDetectionResult = widget.edgeDetectionResult;
      _updatePoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: EdgePainter(
        points: points,
        color: Theme.of(context).accentColor.withOpacity(0.5),
      ),
    );
  }

  void _calculateDimensionValues() {
    top = 0.0;
    left = 0.0;

    double widthFactor =
        widget.renderedImageSize.width / widget.originalImageSize.width;
    double heightFactor =
        widget.renderedImageSize.height / widget.originalImageSize.height;
    double sizeFactor = min(widthFactor, heightFactor);

    renderedImageHeight = widget.originalImageSize.height * sizeFactor;
    top = ((widget.renderedImageSize.height - renderedImageHeight) / 2);

    renderedImageWidth = widget.originalImageSize.width * sizeFactor;
    left = ((widget.renderedImageSize.width - renderedImageWidth) / 2);
  }

  void _updatePoints() {
    _calculateDimensionValues();
    // d.log('Debug TopLeft Offset=====================================----=====');
    // d.log('left $left');
    // d.log('dx ${edgeDetectionResult!.topLeft.dx}');
    // d.log('renderWidth $renderedImageWidth');
    // d.log('top $top');
    // d.log('dy ${edgeDetectionResult!.topLeft.dy}');
    // d.log('renderHeight $renderedImageHeight');
    //
    // d.log('left + dx = ${left + edgeDetectionResult!.topLeft.dx}');
    // d.log('left + dx * renderWidth = ${left + edgeDetectionResult!.topLeft.dx * renderedImageWidth}');
    //
    // d.log('top + dy = ${top + edgeDetectionResult!.topLeft.dy}');
    // d.log('top + dy * renderheight = ${top + edgeDetectionResult!.topLeft.dy * renderedImageHeight}');
    //
    // d.log('End of Debug TopLeft Offset=======================================');
    setState(() => points = [
      Offset(
        left + edgeDetectionResult!.topLeft.dx * renderedImageWidth,
        top + edgeDetectionResult!.topLeft.dy * renderedImageHeight,
      ),
      Offset(
        left + edgeDetectionResult!.topRight.dx * renderedImageWidth,
        top + edgeDetectionResult!.topRight.dy * renderedImageHeight,
      ),
      Offset(
        left + edgeDetectionResult!.bottomRight.dx * renderedImageWidth,
        top + (edgeDetectionResult!.bottomRight.dy * renderedImageHeight),
      ),
      Offset(
        left + edgeDetectionResult!.bottomLeft.dx * renderedImageWidth,
        top + edgeDetectionResult!.bottomLeft.dy * renderedImageHeight,
      ),
      Offset(
        left + edgeDetectionResult!.topLeft.dx * renderedImageWidth,
        top + edgeDetectionResult!.topLeft.dy * renderedImageHeight,
      ),
    ]);
  }
}
