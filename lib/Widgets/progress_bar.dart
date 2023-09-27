import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';

class StepProgressView extends StatelessWidget {
  StepProgressView(
    this._curStep,
    this._height,
    this._width,
    this.lineHeight,
    this._dotRadius,
  );

  //height of the container
  final double _height;

  //width of the container
  final double _width;

  //cur step identifier
  final int _curStep;

  //dot radius
  final double _dotRadius;

  //line height
  final double lineHeight;

  final Color _activeColor = Color(0xffFCCC8D);
  final Color _inactiveColor = Color(0xff9AA4FF);

  List<Widget> _buildDots(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var wids = <Widget>[];
    for (var i = 0; i < 3; i++) {
      var circleColor =
          (i == 0 || _curStep > i) ? _activeColor : _inactiveColor;
      var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;
      wids.add(
        CircleAvatar(
          radius: _dotRadius,
          backgroundColor: circleColor,
          child: Text(
            (i + 1).toString(),
            style: (_height > 1000 || width > 400)
                ? TextStyle(color: Color(0xffF7F3ED), fontSize: _height * 0.045)
                : TextStyle(color: Color(0xffF7F3ED)),
          ),
        ),
      );

      //add a line separator
      //0-------0--------0
      if (i != 2) {
        wids.add(
          Expanded(
            child: Container(
              height: lineHeight,
              color: lineColor,
            ),
          ),
        );
      }
    }
    return wids;
  }

  Widget build(BuildContext context) {
    return Container(
      width: this._width,
      decoration: BoxDecoration(color: purpleBG),
      padding: EdgeInsets.only(
        top: this._height * 0.04,
        left: this._width * 0.15,
        right: this._width * 0.15,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: _buildDots(context),
          ),
        ],
      ),
    );
  }
}
