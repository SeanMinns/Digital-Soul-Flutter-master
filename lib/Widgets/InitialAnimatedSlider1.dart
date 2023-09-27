import 'dart:async';
import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'CustomSlider.dart';
import 'dart:ui' as ui;

class InitialAnimatedSliders1 extends StatefulWidget {
  final int answer;
  final int divisions;
  final double height;
  final double width;
  final List<String> images;
  final List<String> text;
  final String question;
  final String subQuestion;
  final Function changeSlider;
  final List<ui.Image> images2;

  InitialAnimatedSliders1(
    this.answer,
    this.divisions,
    this.question,
    this.subQuestion,
    this.images,
    this.text,
    this.changeSlider,
    this.height,
    this.width,
    this.images2,
  );

  @override
  _InitialAnimatedSliders1 createState() => _InitialAnimatedSliders1(
        this.answer,
        this.divisions,
        this.question,
        this.subQuestion,
        this.images,
        this.text,
        this.changeSlider,
        this.height,
        this.width,
        this.images2,
      );
}

class _InitialAnimatedSliders1 extends State<InitialAnimatedSliders1> {
  int answer;
  int divisions;
  final double height;
  final double width;
  List<String> images;
  List<String> text;
  String question;
  String subQuestion;
  List<String> answers = [];
  double pos = 0;
  bool changePage = false;
  int val = 0;
  bool done = false;
  bool done2 = false;
  final Function changeSlider;
  final List<ui.Image> images2;

  bool nextPage = false;
  int pos2 = 0;

  _InitialAnimatedSliders1(
    this.answer,
    this.divisions,
    this.question,
    this.subQuestion,
    this.images,
    this.text,
    this.changeSlider,
    this.height,
    this.width,
    this.images2,
  );

  void initState() {
    super.initState();
    changeImage();
  }

  void changeImage() {
    Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (nextPage == false) {
        if (images2.length == 2) {
          if (pos2 == 0) {
            setState(() {
              pos2 = pos2 + 1;
            });
          } else {
            setState(() {
              pos2 = pos2 - 1;
            });
          }
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    nextPage = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pos = answer.toDouble();
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    print("HEIGHT =" + height.toString());
    print("WIDTH =" + width.toString());
    return images2.length == 2
        ? Scaffold(
            backgroundColor: backGround,
            body: Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.03,
              ),
              child: Column(children: [
                question.length > 0
                    ? Container(
                        margin: EdgeInsets.only(
                            top: height * 0.02, left: width * 0.03),
                        alignment: Alignment.topLeft,
                        child: Text(
                          question,
                          style: styles.getBlueQuestionTextStyle(),
                        ),
                      )
                    : Container(),
                Container(
                  margin: question.length != 0
                      ? EdgeInsets.only(top: height * 0.04)
                      : EdgeInsets.only(top: height * 0.04),
                  alignment: Alignment.topLeft,
                  child: Text(
                    subQuestion,
                    style: styles.getNormalHeading1TextStyle(),
                  ),
                ),
                Container(
                  height: checkTablet(height, width)
                      ? height * 0.15
                      : height > 920
                          ? height * 0.15
                          : height * 0.2,
                  margin: question.length > 0
                      ? EdgeInsets.only(
                          top: checkTablet(height, width)
                              ? height * 0.01
                              : height >= 920
                                  ? height * 0.04
                                  : height * 0.028)
                      : EdgeInsets.only(
                          top: checkTablet(height, width)
                              ? height * 0.06
                              : height * 0.07,
                          bottom: checkTablet(height, width)
                              ? height * 0.03
                              : height * 0.05),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      images[pos.toInt()],
                      key: ValueKey<int>(pos.toInt()),
                      height: checkTablet(height, width)
                          ? height * 0.15
                          : height > 920
                              ? height * 0.15
                              : height * 0.2,
                      filterQuality: FilterQuality.high,
                      scale: checkTablet(height, width) ? 0.75 : 1,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: checkTablet(height, width) ? 25 : 22.0,
                  ),
                  margin: EdgeInsets.only(bottom: height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        divisions + 1,
                        (index) => Text(
                              (index + 1).toString(),
                              style: GoogleFonts.nunito(
                                  fontSize: height > 800 ? 22 : 12),
                            )),
                  ),
                ),
                Center(
                  child: Container(
                    margin: question.length > 0
                        ? EdgeInsets.only(top: 0)
                        : EdgeInsets.only(top: height * 0.005),
                    padding: EdgeInsets.only(top: 0),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: (height > 920 && width >= 400) ? 6 : 2,
                        inactiveTickMarkColor: textDarkgrey,
                        activeTickMarkColor: textDarkgrey,
                        activeTrackColor: textDarkgrey,
                        inactiveTrackColor: textDarkgrey,
                        thumbShape: SliderThumbImage(images2[pos2.toInt()]),
                        tickMarkShape: RoundSliderTickMarkShape(
                          tickMarkRadius: checkTablet(height, width) ? 7 : 3,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                            overlayRadius:
                                checkTablet(height, width) ? 32 : 24),
                      ),
                      child: Container(
                        height: checkTablet(height, width)
                            ? height * 0.04
                            : height * 0.02,
                        child: Slider(
                          value: pos,
                          max: divisions.toDouble(),
                          min: 0,
                          divisions: divisions,
                          onChangeStart: (double value) {
                            print("Tapped");
                            setState(() {
                              nextPage = true;
                            });
                            changeSlider();
                          },
                          onChanged: (double value) {},
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: question.length > 0
                        ? EdgeInsets.only(
                            top: height * 0.02, bottom: height * 0.001)
                        : EdgeInsets.only(top: height * 0.03),
                    child: Text(
                      text[pos.toInt()],
                      style: styles.getNormalTextStyle(),
                    ),
                  ),
                ),
              ]),
            ),
          )
        : Container();
  }
}
