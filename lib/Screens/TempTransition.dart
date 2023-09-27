import 'package:flutter/material.dart';

class TempTransition extends StatefulWidget {
  final int pos;
  final List<Widget> samplePages;
  final PageController controller;
  final Duration kDuration;
  final Cubic kCurve;
  final Function changePos;

  TempTransition(
    this.pos,
    this.samplePages,
    this.controller,
    this.kDuration,
    this.kCurve,
    this.changePos,
  );

  @override
  _TempTransitionState createState() => _TempTransitionState();
}

class _TempTransitionState extends State<TempTransition> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.controller,
      itemCount: widget.samplePages.length,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return widget.samplePages[index % widget.samplePages.length];
      },
    );
  }
}
