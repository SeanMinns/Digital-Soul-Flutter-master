import 'dart:async';
import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'CustomSlider.dart';
import '../Widgets/CommonWidgets.dart';

class SliderQuestion extends StatefulWidget {
  final Function saveAnswers;
  final String question;
  final int type;
  final double emotion;
  final double stress;
  final Function changeFilled;
  final double h;
  final double w;
  final Function changeInitialSlider;
  final bool initialSlider;
  SliderQuestion(
    this.question,
    this.type,
    this.emotion,
    this.stress,
    this.saveAnswers,
    this.changeFilled,
    this.h,
    this.w,
    this.changeInitialSlider,
    this.initialSlider,
  );

  @override
  _SliderQuestion createState() => _SliderQuestion(
        this.question,
        this.type,
        this.emotion,
        this.stress,
        this.saveAnswers,
        this.changeFilled,
        this.h,
        this.w,
        this.changeInitialSlider,
        this.initialSlider,
      );
}

class _SliderQuestion extends State<SliderQuestion> {
  double emotion;
  double stress;
  final double h;
  final double w;
  List<ui.Image> images = [];
  List imageAssets = [
    'assets/emotion1.png',
    'assets/emotion2.png',
    'assets/emotion3.png',
    'assets/emotion4.png',
    'assets/emotion5.png',
    'assets/emotion6.png',
    'assets/stress1.png',
    'assets/stress2.png',
    'assets/stress3.png',
    'assets/stress4.png',
    'assets/stress5.png',
    'assets/stress6.png',
    'assets/emotion1_glow.png',
    'assets/stress1_glow.png'
  ];
  final Function changeInitialSlider;
  int val = 0;
  bool done = false;
  Function saveAnswers;
  String question;
  int type;
  Function changeFilled;
  bool initialSlider;
  int pos2 = 0;
  int pos3 = 0;

  _SliderQuestion(
    this.question,
    this.type,
    this.emotion,
    this.stress,
    this.saveAnswers,
    this.changeFilled,
    this.h,
    this.w,
    this.changeInitialSlider,
    this.initialSlider,
  );

  Future<bool> loadImage(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: (val != 12 && val != 13)
          ? (checkTablet(h, w) ? 50 : 40)
          : checkTablet(h, w)
              ? 60
              : 50,
      targetHeight: (val != 12 && val != 13)
          ? (checkTablet(h, w) ? 50 : 40)
          : checkTablet(h, w)
              ? 60
              : 50,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      images.add(fi.image);
    });
    return true;
  }

  void loadAllIcons() async {
    if (val != 14) {
      done = await loadImage(imageAssets[val]);
      if (done) {
        val++;
        loadAllIcons();
      }
    }
  }

  void changeImage() {
    Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (initialSlider == false) {
        if (images.length == 14) {
          if (pos2 == 0 || pos3 == 6) {
            setState(() {
              pos2 = 12;
              pos3 = 13;
            });
          } else {
            setState(() {
              pos2 = 0;
              pos3 = 6;
            });
          }
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  initState() {
    super.initState();
    loadAllIcons();
    changeImage();
  }

  @override
  void dispose() {
    initialSlider = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    print(checkTablet(height, width));
    return images.length == 14
        ? Container(
            color: backGround,
            margin: EdgeInsets.symmetric(
              vertical: height * 0.05,
              horizontal: width * 0.06,
            ),
            child: Column(
              children: [
                Container(
                  child: Text(
                    question,
                    style: styles.getQuestionTextStyle(),
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Center(
                  child: Container(
                    height: checkTablet(height, width)
                        ? height * 0.089
                        : height * 0.05,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: checkTablet(h, w) ? 4 : 3,
                        thumbShape: initialSlider == false
                            ? SliderThumbImage(images[pos2])
                            : SliderThumbImage(images[emotion.toInt()]),
                        inactiveTickMarkColor: textDarkgrey,
                        activeTickMarkColor: textDarkgrey,
                        activeTrackColor: textDarkgrey,
                        inactiveTrackColor: textDarkgrey,
                        overlayColor: Colors.white,
                        overlayShape: RoundSliderOverlayShape(
                            overlayRadius:
                                checkTablet(height, width) ? 20 : 10),
                        tickMarkShape: RoundSliderTickMarkShape(
                            tickMarkRadius: checkTablet(height, width) ? 5 : 4),
                      ),
                      child: Slider(
                        value: emotion,
                        max: 5,
                        min: 0,
                        divisions: 5,
                        onChangeStart: (value) {
                          if (initialSlider == false) {
                            changeInitialSlider(true);
                            changeFilled(true);
                            setState(() {
                              initialSlider = true;
                              emotion = value;
                              if (type == 1) {
                                saveAnswers(1, value.toInt(), stress.toInt());
                              } else {
                                saveAnswers(2, value.toInt(), stress.toInt());
                              }
                            });
                          }
                        },
                        onChanged: (value) {
                          changeFilled(true);
                          setState(() {
                            emotion = value;
                            if (type == 1) {
                              saveAnswers(1, value.toInt(), stress.toInt());
                            } else {
                              saveAnswers(2, value.toInt(), stress.toInt());
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.01),
                    child: Text(
                      emotionText[emotion.toInt()],
                      style: styles.getNormalTextStyle(),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Center(
                  child: Container(
                    height: checkTablet(height, width)
                        ? height * 0.089
                        : height * 0.05,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: checkTablet(h, w) ? 4 : 3,
                        thumbShape: initialSlider == false
                            ? SliderThumbImage(images[pos3])
                            : SliderThumbImage(images[stress.toInt() + 6]),
                        inactiveTickMarkColor: textDarkgrey,
                        activeTickMarkColor: textDarkgrey,
                        activeTrackColor: textDarkgrey,
                        inactiveTrackColor: textDarkgrey,
                        overlayColor: Colors.white,
                        overlayShape: RoundSliderOverlayShape(
                            overlayRadius:
                                checkTablet(height, width) ? 20 : 10),
                        tickMarkShape: RoundSliderTickMarkShape(
                            tickMarkRadius: checkTablet(height, width) ? 5 : 4),
                      ),
                      child: Slider(
                        value: stress,
                        max: 5,
                        min: 0,
                        divisions: 5,
                        onChangeStart: (value) {
                          if (initialSlider == false) {
                            changeInitialSlider(true);
                            changeFilled(true);
                            setState(() {
                              stress = value;
                              initialSlider = true;
                              if (type == 1) {
                                saveAnswers(1, emotion.toInt(), value.toInt());
                              } else {
                                saveAnswers(2, emotion.toInt(), value.toInt());
                              }
                            });
                          }
                        },
                        onChanged: (value) {
                          changeFilled(true);
                          setState(() {
                            stress = value;
                            if (type == 1) {
                              saveAnswers(1, emotion.toInt(), value.toInt());
                            } else {
                              saveAnswers(2, emotion.toInt(), value.toInt());
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.01),
                    child: Text(
                      stressText[stress.toInt()],
                      style: styles.getNormalTextStyle(),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: backGround,
          );
  }
}
