import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:digital_soul/Widgets/AnimatedSliders.dart';
import 'package:digital_soul/Widgets/ColoredButtonQuestion.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/GradientProgressBar.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/sets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class SetScreen2 extends StatefulWidget {
  const SetScreen2({Key? key}) : super(key: key);

  @override
  _SetScreen2State createState() => _SetScreen2State();
}

class _SetScreen2State extends State<SetScreen2> {
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 800);
  static const _kCurve = Curves.ease;
  int pos = 0;
  bool _isLoading = false;
  List<bool>? _isFilled;
  List<dynamic>? answers;
  List<bool>? _isFirst;
  String? selectedMcq;
  bool bluetext = true;
  List thumb = [
    Color(0xff61E2A2),
    Color(0xff8ACA9B),
    Color(0xffFC9288),
    Color(0xffF98988)
  ];
  OverlayEntry entry = loading();

  List<int> time = [];
  late Stopwatch _stopwatch;
  List<ui.Image> images2 = [];
  bool done = false;

  void showOverlay(bool isLoading, BuildContext context) {
    if (isLoading == false) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => Overlay.of(context)!.insert(entry));
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) => entry.remove());
    }
  }

  @override
  void dispose() {
    //_animationController.dispose();
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    }
    entry.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _isFilled = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];

    _isFirst = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];

    time = [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
    ];
    answers = [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      [true, false, false, false]
    ];

    selectedMcq = '';
    _stopwatch = Stopwatch();
    handleStartStop(0, pos);
    loadAllIcons();
    super.initState();
  }

  void handleStartStop(int i, int p) {
    //Stopwatch function.
    if (i == 0) {
      if (_stopwatch.isRunning) {
        time[p] = time[p] + (_stopwatch.elapsedMilliseconds / 1000).round();
        print(_stopwatch.elapsedMilliseconds / 1000); // way to get time
        _stopwatch.stop();
        _stopwatch.reset();
        _stopwatch.start();
      } else {
        _stopwatch.start();
      }
    } else if (i == 1) {
      _stopwatch.stop();
      time[p] = time[p] + (_stopwatch.elapsedMilliseconds / 1000).round();
    }
  }

  void changePos(value) {
    setState(() {
      pos = value;
    });
    bringBlueText();
  }

  void changeIsFilled(bool value) {
    setState(() {
      _isFilled![pos] = value;
    });
  }

  void nextPage() async {
    if (pos != 7) {
      handleStartStop(0, pos);
      changePos(pos + 1);
      _controller.nextPage(duration: _kDuration, curve: _kCurve);
    } else {
      handleStartStop(1, pos);
      try {
        setState(() {
          _isLoading = true;
        });
        showOverlay(false, context);
        List<String> set5Questions = [
          "Over the last two weeks, how often have you been bothered by... Feeling nervous, anxious, or on edge",
          "Over the last two weeks, how often have you been bothered by... Not being able to stop or control worrying",
          "Over the last two weeks, how often have you been bothered by... Worrying too much about different things",
          "Over the last two weeks, how often have you been bothered by... Trouble relaxing",
          "Over the last two weeks, how often have you been bothered by... Being so restless that it is hard to sit still",
          "Over the last two weeks, how often have you been bothered by... Becoming easily annoyed or irritable",
          "Over the last two weeks, how often have you been bothered by... Feeling afraid, as if something awful might happen",
          "If you checked any problems, how difficult have they made it for you to do your work, take care of things at home, or get along with other people?",
        ];
        List<dynamic> answerData = [];
        for (int i = 0; i < 7; i++) {
          // answerData.add(set5SliderText[answers![i]]);
          answerData.add(answers![i] + 1);
        }
        var selectedIndex =
            List<bool>.from(answers![7]).indexWhere((element) => element);
        selectedMcq = buttonQuestionAnswers[selectedIndex];
        answerData.add(selectedMcq);
        print(answerData);
        await Provider.of<Sets>(context, listen: false).addSet(
          2,
          set5Questions,
          answerData,
          time,
        );
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        await overlayPopup(
          'assets/Set2popup.png',
          'You\'re Doing Great!',
          'Such a sport! You have finished another set and have only 4 more questionnaires to go.',
          'KEEP GOING!',
          context,
          0.95,
        );
        Navigator.popAndPushNamed(context, ScreenNavigationConstant.Set3Screen);
      } on HttpException catch (_) {
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        overlayPopup(
          'assets/server_error.png',
          'Oops!',
          'There seems to be an internal server error. Please try again in some time.',
          'OKAY',
          context,
          0.9,
        );
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        print(error);
        bool isOnline = await hasNetwork();
        if (!isOnline) {
          overlayPopup(
            'assets/no_internet.png',
            'No Internet!',
            'Please check if you have proper internet connection to continue.',
            'OKAY',
            context,
            0.9,
          );
        }
      }
    }
  }

  void prevPage() {
    handleStartStop(0, pos);
    if (pos != 0) {
      changePos(pos - 1);
      _controller.previousPage(
        duration: _kDuration,
        curve: _kCurve,
      );
    } else {
      handleStartStop(1, pos);
      Navigator.of(context).pop();
    }
  }

  void bringBlueText() {
    if (pos >= 0 && pos <= 6) {
      if (bluetext == false) {
        setState(() {
          bluetext = true;
        });
      }
    } else {
      if (bluetext == true) {
        setState(() {
          bluetext = false;
        });
      }
    }
  }

  void saveSliderAnswers1(int level) {
    if (set5SliderText[level].length > 0) {
      // setState(() {
      answers![0] = level;
      // });
    }
  }

  void saveSliderAnswers2(int level) {
    if (set5SliderText[level].length > 0) {
      // setState(() {
      answers![1] = level;
      // });
    }
  }

  void saveSliderAnswers3(int level) {
    if (set5SliderText[level].length > 0) {
      // setState(() {
      answers![2] = level;
      // });
    }
  }

  void saveSliderAnswers4(int level) {
    if (set5SliderText[level].length > 0) {
      // setState(() {
      answers![3] = level;
      // });
    }
  }

  void saveSliderAnswers5(int level) {
    if (set5SliderText[level].length > 0) {
      // setState(() {
      answers![4] = level;
      // });
    }
  }

  void saveSliderAnswers6(int level) {
    if (set5SliderText[level].length > 0) {
      // setState(() {
      answers![5] = level;
      // });
    }
  }

  void saveSliderAnswers7(int level) {
    if (set5SliderText[level].length > 0) {
      // setState(() {
      answers![6] = level;
      // });
    }
  }

  void saveButtonAnswer(List ans) {
    if (ans.length > 0) {
      answers![7] = ans;
    }
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
    done = await loadImage(thumbGreen[0]);
    if (done) {
      done = await loadImage(thumbGreen[1]);
      if (done == false) {
        print("error");
      }
    } else {
      print("error");
    }
  }

  void changeInitialSlider(bool value) {
    setState(() {
      _isFirst![pos] = value;
    });
    /*setState(() {
      isFirst = false;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Opacity(
              opacity: _isLoading ? 0.3 : 1,
              child: IgnorePointer(
                ignoring: _isLoading,
                child: SizedBox(
                  height: height,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          color: set2color,
                          height: height * 0.15,
                          padding: EdgeInsets.only(top: height * 0.04),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "Question " + (pos + 1).toString() + "/8",
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: height * 0.03,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.01,
                                ),
                                child: GradientProgressBar(
                                  size: 15,
                                  totalSteps: 8,
                                  curStep: pos + 1,
                                  leftColor: Color(0xffFC8787),
                                  rightColor: Color(0xff5FE3A2),
                                  unselectedColor: Color(0xffE5E5E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        bluetext
                            ? Container(
                                margin: EdgeInsets.only(
                                  top: height * 0.015,
                                  left: width * 0.03,
                                ),
                                //alignment: Alignment.topLeft,
                                child: Text(
                                  'Over the last two weeks, how often have you been bothered by...',
                                  style: styles.getBlueQuestionTextStyle(),
                                ),
                              )
                            : Container(),
                        Container(
                          color: Colors.white,
                          height: bluetext == false
                              ? height * 0.65
                              : height >= 1000
                                  ? height * 0.5
                                  : height * 0.55,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: 8,
                            physics: new NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return [
                                AnimatedSliders(
                                  answers![0],
                                  3,
                                  '',
                                  'Feeling nervous, anxious, or on edge',
                                  set5SliderImages,
                                  thumb,
                                  set5SliderText,
                                  saveSliderAnswers1,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![0],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![1],
                                  3,
                                  '',
                                  'Not being able to stop or control worrying',
                                  set5SliderImages,
                                  thumb,
                                  set5SliderText,
                                  saveSliderAnswers2,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![1],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![2],
                                  3,
                                  '',
                                  'Worrying too much about different things',
                                  set5SliderImages,
                                  thumb,
                                  set5SliderText,
                                  saveSliderAnswers3,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![2],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![3],
                                  3,
                                  '',
                                  'Trouble relaxing',
                                  set5SliderImages,
                                  thumb,
                                  set5SliderText,
                                  saveSliderAnswers4,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![3],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![4],
                                  3,
                                  '',
                                  'Being so restless that it is hard to sit still',
                                  set5SliderImages,
                                  thumb,
                                  set5SliderText,
                                  saveSliderAnswers5,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![4],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![5],
                                  3,
                                  '',
                                  'Becoming easily annoyed or irritable',
                                  set5SliderImages,
                                  thumb,
                                  set5SliderText,
                                  saveSliderAnswers6,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![5],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![6],
                                  3,
                                  '',
                                  'Feeling afraid, as if something awful might happen',
                                  set5SliderImages,
                                  thumb,
                                  set5SliderText,
                                  saveSliderAnswers7,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![6],
                                  changeInitialSlider,
                                  images2,
                                ),
                                ColoredButtonQuestion(
                                  'If you checked any problems, how difficult have they made it for you to do your work, take care of things at home, or get along with other people?',
                                  buttonQuestionColors,
                                  buttonQuestionAnswers,
                                  changeIsFilled,
                                  saveButtonAnswer,
                                  answers![7],
                                ),
                              ][index % 8];
                            },
                          ),
                        ),
                        //SizedBox(height: height*0.01,),
                        Spacer(),
                        pos == 0
                            ? NavigateButtons(
                                pos != 7 ? 'NEXT' : 'FINISH',
                                'BACK',
                                _isFilled![pos],
                                height,
                                width,
                                context,
                                nextPage,
                                prevPage,
                                0,
                              )
                            : NavigateButtons(
                                pos != 7 ? 'NEXT' : 'FINISH',
                                'BACK',
                                _isFilled![pos],
                                height,
                                width,
                                context,
                                nextPage,
                                prevPage,
                                1,
                              ),
                        Footer(height, width),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
