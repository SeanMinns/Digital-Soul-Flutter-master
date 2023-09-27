import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final double width;
  final double height;

  Footer(this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height * 0.1,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: textGrey,
                blurRadius: 10,
                spreadRadius: 0.0,
                offset: Offset(-5, 0) // Shadow position
                )
          ],
        ),
        child: Center(
          child: Image.asset(
            "assets/hospitalLogo.png",
            scale: checkTablet(height, width) ? 1.25 : 3,
          ),
        ),
      ),
    );
  }
}
