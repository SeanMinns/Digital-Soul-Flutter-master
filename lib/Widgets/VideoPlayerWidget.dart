import 'package:digital_soul/Widgets/VideoOverlay.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final double height;
  final double width;

  const VideoPlayerWidget({
    required this.controller,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return (controller.value.isInitialized
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.05),
            alignment: Alignment.topCenter,
            child: buildVideo(),
          )
        : Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.05),
            height: height * 0.5,
            decoration: BoxDecoration(
              color: Color.fromRGBO(80, 83, 89, 1),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ));
  }

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
          Positioned.fill(
            child: BasicOverlayWidget(controller: controller),
          ),
        ],
      );

  Widget buildVideoPlayer() {
    /*return Container(
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      ),
    ););*/
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );
  }
}
