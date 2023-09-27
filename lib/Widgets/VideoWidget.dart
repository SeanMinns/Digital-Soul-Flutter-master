import 'package:digital_soul/Constants/VideoLinks.dart';
import 'package:digital_soul/Widgets/VideoPlayerWidget.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final double height;
  final double width;
  final Function buttonDisable;
  final bool isLesson;
  final int lesson;

  VideoWidget(
      this.height, this.width, this.buttonDisable, this.isLesson, this.lesson);

  @override
  _VideoWidgetState createState() => _VideoWidgetState(
      this.height, this.width, this.buttonDisable, this.isLesson, this.lesson);
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController controller;
  double height;
  double width;
  String link = "";
  bool loadingVideo = false;
  Function buttonDisable;
  final bool isLesson;
  final int lesson;
  int count = -1;

  _VideoWidgetState(
      this.height, this.width, this.buttonDisable, this.isLesson, this.lesson);

  @override
  void initState() {
    super.initState();
    if (isLesson) {
      if (Provider.of<Lessons>(context, listen: false).captions[lesson]) {
        if (lesson == 0) {
          link = VideoLinks.lesson1WithCaption;
        } else if (lesson == 1) {
          link = VideoLinks.lesson2WithCaption;
        } else if (lesson == 2) {
          link = VideoLinks.lesson3WithCaption;
        } else if (lesson == 3) {
          link = VideoLinks.lesson4WithCaption;
        } else if (lesson == 4) {
          link = VideoLinks.lesson5WithCaption;
        }
      } else {
        if (lesson == 0) {
          link = VideoLinks.lesson1;
        } else if (lesson == 1) {
          link = VideoLinks.lesson2;
        } else if (lesson == 2) {
          link = VideoLinks.lesson3;
        } else if (lesson == 3) {
          link = VideoLinks.lesson4;
        } else if (lesson == 4) {
          link = VideoLinks.lesson5;
        }
      }
    } else {
      link = VideoLinks.introVideo;
    }
    _initVideo();
  }

  void _initVideo() {
    //function to initialise video
    controller = VideoPlayerController.network(link)
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((_) {
        controller.addListener(() {
          //custom Listner
          if (!controller.value.isPlaying &&
              controller.value.isInitialized &&
              (controller.value.duration == controller.value.position)) {
            //checking the duration and position every time
            //Video Completed//
            buttonDisable(true);
            print('ENDED');
            //HERE WE COULD DO FUNCTION CALL TO SET A VARIABLE TO CHECK IF VIDEO ENDED OR NOT
          }
        });
      });
  }

  @override
  void didUpdateWidget(covariant VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (isLesson) {
      if (controller.value.isInitialized &&
          controller.value.isPlaying == true) {
        controller.pause();
        count++;
      }
      if (controller.value.isInitialized &&
          controller.value.duration != controller.value.position &&
          controller.value.isPlaying == false) {
        count++;
        controller.pause();
        if (count == 2) {
          count = 0;
          controller.dispose();
          if (Provider.of<Lessons>(context, listen: false).captions[lesson]) {
            if (lesson == 0) {
              link = VideoLinks.lesson1WithCaption;
            } else if (lesson == 1) {
              link = VideoLinks.lesson2WithCaption;
            } else if (lesson == 2) {
              link = VideoLinks.lesson3WithCaption;
            } else if (lesson == 3) {
              link = VideoLinks.lesson4WithCaption;
            } else if (lesson == 4) {
              link = VideoLinks.lesson5WithCaption;
            }
            _initVideo();
          } else {
            if (lesson == 0) {
              link = VideoLinks.lesson1;
            } else if (lesson == 1) {
              link = VideoLinks.lesson2;
            } else if (lesson == 2) {
              link = VideoLinks.lesson3;
            } else if (lesson == 3) {
              link = VideoLinks.lesson4;
            } else if (lesson == 4) {
              link = VideoLinks.lesson5;
            }
            _initVideo();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loadingVideo == false
        ? GestureDetector(
            onTap: () {
              controller.play();
              setState(() {
                loadingVideo = true;
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: width * 0.05),
              height: height * 0.5,
              // width: checkTablet(height, width) ? width * 0.8 : width * 0.9,
              decoration: BoxDecoration(
                color: Color.fromRGBO(80, 83, 89, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    width: height * 0.1,
                    height: height * 0.1,
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(196, 196, 196, 1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: height * 0.1,
                  ),
                ],
              ),
            ),
          )
        : Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                VideoPlayerWidget(
                  controller: controller,
                  height: height,
                  width: width,
                ),
              ],
            ),
          );
  }
}
