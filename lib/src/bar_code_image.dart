import 'package:flutter/material.dart';

import 'bar_code_painter.dart';

class BarCodeImage extends StatelessWidget {
  final String sourceData;
  final double width;
  final double height;
  final Color barCodeLineColor;
  final Color backgroundColor;

  const BarCodeImage(
    this.sourceData, {
    Key key,
    @required this.width,
    @required this.height,
    this.barCodeLineColor = Colors.black,
    this.backgroundColor = Colors.white,
  })  : assert(
          width != 0 && height != 0,
          'width and height can not be 0',
        ),
        assert(
          sourceData != null,
          'sourceData can not be null',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: CustomPaint(
        painter: BarCodePainter(sourceData: sourceData, barCodeLineColor: barCodeLineColor),
      ),
    );
  }
}
