import 'dart:async';
import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/CustomSlider.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:flutter/material.dart';
import '../Widgets/CommonWidgets.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class TutorialScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TutorialScreen();
  }
}

class _TutorialScreen extends State<TutorialScreen> {
  double pos = 0;
  List images = tutorial;
  bool show = true;
  List<ui.Image> images2 = [];
  bool done = false;
  bool initialSlider = false;
  int pos2 = 0;

  @override
  void initState() {
    loadAllIcons();
    changeImage();
    super.initState();
  }

  Future<bool> loadImage(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: isTab ? 50 : 40,
      targetHeight: isTab ? 50 : 40,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      images2.add(fi.image);
    });
    return true;
  }

  void loadAllIcons() async {
    done = await loadImage(thumbBrown[0]);
    if (done) {
      done = await loadImage(thumbBrown[1]);
      if (done == false) {
        print("error");
      }
    } else {
      print("error");
    }
  }

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
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);

    return images2.length == 2
        ? WillPopScope(
            onWillPop: () async => false,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: purpleBG,
                body: Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: height * 0.07),
                        child: Text(
                          'Try it Out!',
                          style: styles.getWhiteHeading(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.01),
                        padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                        child: Text(
                          'Why don’t you try and see what happens when you move the slider all the way to the end?',
                          style: styles.getNormalWhiteTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: height * 0.2,
                        margin: EdgeInsets.only(top: height * 0.1),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Image.asset(
                            images[pos.toInt()],
                            key: ValueKey<int>(pos.toInt()),
                            height: height * 0.2,
                            filterQuality: FilterQuality.high,
                            scale: (height >= 920 || width >= 400) ? 0.75 : 1,
                          ),
                        ),
                      ),
                      /*Image.asset(
                    images[pos.toInt()],
                    height: height * 0.2,
                  ),*/
                      Row(
                        children: [
                          Visibility(
                            visible: show,
                            child: Container(
                              child: Image.asset(
                                'assets/redPlay.png',
                                scale: checkTablet(height, width) ? 0.6 : 0.9,
                              ),
                              margin: EdgeInsets.only(left: 10),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              // margin: EdgeInsets.only(top: height * 0.01),
                              width: width,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: (height > 920 || width >= 400)
                                      ? height >= 920
                                          ? 4
                                          : 2
                                      : 2,
                                  inactiveTickMarkColor: textGrey,
                                  activeTickMarkColor: textGrey,
                                  activeTrackColor: textGrey,
                                  inactiveTrackColor: textGrey,
                                  thumbColor: buttonColor,
                                  thumbShape: initialSlider
                                      ? RoundSliderThumbShape(
                                          enabledThumbRadius:
                                              (height > 920 || width >= 400)
                                                  ? height >= 920
                                                      ? 17
                                                      : 10
                                                  : 10,
                                        )
                                      : SliderThumbImage(images2[pos2.toInt()]),
                                  tickMarkShape: RoundSliderTickMarkShape(
                                    tickMarkRadius:
                                        (height > 920 || width >= 400)
                                            ? height >= 920
                                                ? 5
                                                : 3
                                            : 3,
                                  ),
                                ),
                                child: Slider(
                                  value: pos,
                                  max: 3,
                                  min: 0,
                                  divisions: 3,
                                  onChanged: (value) {
                                    setState(() {
                                      pos = value;
                                    });
                                  },
                                  onChangeStart: (value) {
                                    if (show) {
                                      setState(() {
                                        show = false;
                                        initialSlider = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      pos == 3
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.08),
                              margin: EdgeInsets.only(top: height * 0.05),
                              child: Text(
                                'Wasn’t that fun? You’re now ready to get started with our six questionnaires.',
                                style: styles.getNormalWhiteTextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(),
                      Spacer(),
                      pos == 3
                          ? NavigateButtons(
                              "NEXT",
                              "BACK",
                              true,
                              height,
                              width,
                              context,
                              () {
                                Navigator.of(context).pushNamed(
                                    ScreenNavigationConstant.Set1Screen);
                              },
                              () {},
                              0,
                            )
                          : Container(),
                      Footer(height, width),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
