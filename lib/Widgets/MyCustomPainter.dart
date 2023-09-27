import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyCustomPainter extends CustomPainter {
  ui.Image image;
  MyCustomPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    //ByteData data = image.toByteData() as ByteData;c
    canvas.drawImage(image, new Offset(-10, -100), new Paint());
    // canvas.scale(1,1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
