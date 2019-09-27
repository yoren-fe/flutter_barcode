import 'package:flutter/material.dart';
import 'bar_code_type/code128c.dart';

class BarCodePainter extends CustomPainter {
  final String sourceData;
  final Color barCodeLineColor;

  BarCodePainter({this.sourceData, this.barCodeLineColor});

  @override
  void paint(Canvas canvas, Size size) {
    _drawBarCode128(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _drawBarCode128(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    final painter = Paint()
      ..style = PaintingStyle.fill
      ..color = barCodeLineColor;
    List<int> codes = Code123C.stringToCode128(sourceData);
    double barWeight = width / ((codes.length - 3) * 11 + 35);
    double x = 0;
    double y = 0;
    for (int i = 0; i < codes.length; i++) {
      int c = codes[i];
      //two bars at a time: 1 black and 1 white
      for (int bar = 0; bar < 8; bar += 2) {
        double barW = PATTERNS[c][bar] * barWeight;
        // int barH = height - y - this.border;
        double barH = height - y;
        double spcW = PATTERNS[c][bar + 1] * barWeight;

        //no need to draw if 0 width
        if (barW > 0) {
          Rect rect = Rect.fromLTWH(x, y, barW, barH);
          canvas.drawRect(rect, painter);
        }
        x += barW + spcW;
      }
    }
  }
}
