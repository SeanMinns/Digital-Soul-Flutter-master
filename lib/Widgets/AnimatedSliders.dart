import 'dart:async';
import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;

import 'CustomSlider.dart';

/*import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';
import 'package:digital_soul/Widgets/MyCustomPainter.dart';*/
//ignore: must_be_immutable
class AnimatedSliders extends StatefulWidget {
  final int answer;
  final int divisions;
  final List<String> images;
  final List<String> text;
  final String question;
  final String subQuestion;
  final Function changeFilled;
  final Function saveAnswers;
  final List thumbColor;
  final Function nextPage;
  final Function changeSlider;
  final List<ui.Image> images2;
  bool initialSlider = false;

  AnimatedSliders(
    this.answer,
    this.divisions,
    this.question,
    this.subQuestion,
    this.images,
    this.thumbColor,
    this.text,
    this.saveAnswers,
    this.changeFilled,
    this.nextPage,
    this.initialSlider,
    this.changeSlider,
    this.images2,
  );

  @override
  _AnimatedSliders createState() => _AnimatedSliders(
        this.answer,
        this.divisions,
        this.question,
        this.subQuestion,
        this.images,
        this.thumbColor,
        this.text,
        this.saveAnswers,
        this.changeFilled,
        this.nextPage,
        this.initialSlider,
        this.changeSlider,
        this.images2,
      );
}

class _AnimatedSliders extends State<AnimatedSliders> {
  int answer;
  int divisions;
  List<String> images;
  List<String> text;
  String question;
  String subQuestion;
  Function changeFilled;
  Function saveAnswers;
  List<String> answers = [];
  double pos = 0;
  bool changePage = false;
  Function nextPage;
  final List thumbColor;
  final Function changeSlider;
  final List<ui.Image> images2;
  bool initialSlider = false;
  int pos2 = 0;

  /*late ui.Image image;
  bool isImageloaded = false;
  List<ui.Image> imagesAssets = [];
  int val = 0;
  bool done = false;*/

  _AnimatedSliders(
    this.answer,
    this.divisions,
    this.question,
    this.subQuestion,
    this.images,
    this.thumbColor,
    this.text,
    this.saveAnswers,
    this.changeFilled,
    this.nextPage,
    this.initialSlider,
    this.changeSlider,
    this.images2,
  );

  void initState() {
    super.initState();
    changeImage();
  }

  @override
  void dispose() {
    initialSlider = true;
    super.dispose();
  }

  /*Future<bool> loadImage(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      imagesAssets.add(fi.image);
    });
    return true;
  }

  void loadAllIcons() async {
    if (val != divisions+1) {
      done = await loadImage(images[val]);
      if (done) {
        val++;
        loadAllIcons();
      }
    }
  }*/

  void changeImage() {
    Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (initialSlider == false) {
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
  Widget build(BuildContext context) {
    pos = answer.toDouble();
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    return images2.length == 2
        ? Scaffold(
            backgroundColor: backGround,
            body: Container(
              margin: EdgeInsets.symmetric(
                //vertical: height * 0.02,
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
                      : EdgeInsets.only(top: height * 0.01),
                  alignment: Alignment.topLeft,
                  child: Text(
                    subQuestion,
                    style: styles.getNormalHeadingTextStyle(),
                  ),
                ),
                Container(
                  height: checkTablet(height, width)
                      ? height * 0.15
                      : height > 800
                          ? height * 0.15
                          : height * 0.17,
                  margin: question.length > 0
                      ? EdgeInsets.only(
                          top: checkTablet(height, width)
                              ? height * 0.005
                              : height >= 800
                                  ? height * 0.03
                                  : height * 0.02)
                      : EdgeInsets.only(
                          top: checkTablet(height, width)
                              ? height * 0.03
                              : height * 0.05,
                          bottom: checkTablet(height, width)
                              ? height * 0.03
                              : height * 0.05),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    // transitionBuilder: (Widget child, Animation<double> animation) {
                    //   return ScaleTransition(child: child, scale: animation);
                    // },

                    /*child:CustomPaint(
              painter: MyCustomPainter(imagesAssets[pos.toInt()]),
              ),*/
                    /*child:SvgPicture.asset(
                  images[pos.toInt()],
                  semanticsLabel: 'Images',
                height:height * 0.2,
                key:ValueKey<int>(pos.toInt()) ,
              ),*/
                    child: Image.asset(
                      images[pos.toInt()],
                      key: ValueKey<int>(pos.toInt()),
                      height: checkTablet(height, width)
                          ? height * 0.15
                          : height > 800
                              ? height * 0.15
                              : height * 0.2,
                      filterQuality: FilterQuality.high,
                      scale: checkTablet(height, width) ? 0.85 : 0.9,
                    ),
                  ),
                ),
                /*Container(
            padding: EdgeInsets.symmetric(horizontal: 17.0,vertical: (height>920)?height*0:height*0.01),
            margin: EdgeInsets.only(top:(height>920)?height*0:height*0.01,bottom:0,left: width*0.018),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(divisions+1, (index) => Text((index+1).toString(),style:GoogleFonts.nunito(fontSize: height>=1000?height*0.026:height*0.02))),
            ),
          ),*/
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: checkTablet(height, width) ? 25 : 22.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        divisions + 1,
                        (index) => Text((index + 1).toString(),
                            style: GoogleFonts.nunito(
                                fontSize: height > 800 ? 22 : 12))),
                  ),
                ),
                SizedBox(
                  height: checkTablet(height, width)
                      ? height * 0.00
                      : height * 0.00,
                ),
                Center(
                  child: Container(
                    margin: question.length > 0
                        ? EdgeInsets.only(top: 0)
                        : EdgeInsets.only(top: height * 0),
                    padding: EdgeInsets.only(top: 0),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: (height > 920 && width >= 400) ? 6 : 2,
                        inactiveTickMarkColor: textDarkgrey,
                        activeTickMarkColor: textDarkgrey,
                        activeTrackColor: textDarkgrey,
                        inactiveTrackColor: textDarkgrey,
                        thumbColor: thumbColor[pos.toInt()],
                        thumbShape: initialSlider
                            ? RoundSliderThumbShape(
                                enabledThumbRadius:
                                    checkTablet(height, width) ? 19 : 12,
                              )
                            : SliderThumbImage(images2[pos2.toInt()]),
                        tickMarkShape: RoundSliderTickMarkShape(
                          tickMarkRadius: checkTablet(height, width) ? 7 : 3,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                            overlayRadius:
                                checkTablet(height, width) ? 32 : 24),
                      ),
                      child: Container(
                        child: Slider(
                          value: pos,
                          max: divisions.toDouble(),
                          min: 0,
                          divisions: divisions,
                          onChanged: (value) {
                            setState(() {
                              pos = value;
                              answer = value.toInt();
                              saveAnswers(answer);
                            });
                          },
                          onChangeStart: (value) {
                            if (initialSlider == false) {
                              changeSlider(true);
                              setState(() {
                                initialSlider = true;
                              });
                            }
                          },
                          onChangeEnd: (value) async {
                            setState(() {
                              pos = value;
                              answer = value.toInt();
                              saveAnswers(answer);
                            });
                            if (!changePage) {
                              changePage = true;
                              await Future.delayed(Duration(milliseconds: 500));
                              if (changePage) {
                                changeFilled(true);
                                nextPage();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: question.length > 0
                        ? EdgeInsets.only(
                            top: height * 0.0, bottom: height * 0.00)
                        : EdgeInsets.only(top: height * 0.0),
                    child: Text(
                      text[pos.toInt()],
                      style: GoogleFonts.nunito(
                        fontSize: checkTablet(height, width)
                            ? height * 1.25 * 0.015
                            : height * 0.02,
                        color: textBlack,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          )
        : Container();
  }
}
