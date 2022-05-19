import 'package:flutter/material.dart';

import 'edge_detection_shape/edge_painter.dart';

class AnchorLayer extends StatelessWidget {
  const AnchorLayer({Key? key, required this.boxSize}) : super(key: key);

  final Size boxSize;

  @override
  Widget build(BuildContext context) {
    final Size stripSize = Size(180,450);

    final topLeftx = (boxSize.width/2) - (stripSize.width/2);
    final topLefty = (boxSize.height/2) - (stripSize.height/2);
    final topLeft = Offset(topLeftx,topLefty);

    final topRightx = ((boxSize.width/2) - (stripSize.width/2)) + stripSize.width;
    final topRighty = (boxSize.height/2) - (stripSize.height/2);
    final topRight = Offset(topRightx,topRighty);

    final bottomRightx = ((boxSize.width/2) - (stripSize.width/2)) + stripSize.width;
    final bottomRighty = (boxSize.height/2) - (stripSize.height/2) + stripSize.height;
    final bottomRight = Offset(bottomRightx,bottomRighty);

    final bottomLeftx = ((boxSize.width/2) - (stripSize.width/2));
    final bottomLefty = (boxSize.height/2) - (stripSize.height/2) + stripSize.height;
    final bottomLeft = Offset(bottomLeftx,bottomLefty);


    return CustomPaint(
      painter: EdgePainter(
        points: [
          topLeft,
          topRight,
          bottomRight,
          bottomLeft,
          topLeft,
        ],
        color: Colors.red,
      ),
    );
  }
}
