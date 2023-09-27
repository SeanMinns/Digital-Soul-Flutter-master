import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BasicOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const BasicOverlayWidget({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            controller.value.isPlaying ? controller.pause() : controller.play(),
        child: Stack(
          children: <Widget>[
            buildPlay(MediaQuery.of(context).size.height * 0.07),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildIndicator(),
            ),
          ],
        ),
      );

  Widget buildIndicator() => VideoProgressIndicator(
        controller,
        allowScrubbing: false,
      );

  Widget buildPlay(double height) => controller.value.isPlaying
      ? Container()
      : controller.value.duration != controller.value.position
          ? Container(
              alignment: Alignment.center,
              color: Colors.black26,
              child: Icon(Icons.play_arrow, color: Colors.white, size: height),
            )
          : Container(
              alignment: Alignment.center,
              color: Colors.black26,
              child: Icon(Icons.replay, color: Colors.white, size: height));
}
