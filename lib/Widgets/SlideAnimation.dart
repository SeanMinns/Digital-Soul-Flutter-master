import 'package:flutter/material.dart';

class SlideAnimation extends StatefulWidget {
  final Widget container;
  final double width;

  SlideAnimation(this.container, this.width);

  @override
  _SlideAnimationState createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(widget.width / 50, 0.0),
      end: Offset.zero,
    ).animate(_controller!);
    _controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation!,
      child: widget.container,
    );
  }
}
