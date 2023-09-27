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

class SetScreen3 extends StatefulWidget {
  const SetScreen3({Key? key}) : super(key: key);

  @override
  _SetScreen3State createState() => _SetScreen3State();
}

class _SetScreen3State extends State<SetScreen3> {
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 800);
  static const _kCurve = Curves.ease;
  int pos = 0;
  bool _isLoading = false;
  List<bool>? _isFilled;
  List<dynamic>? answers;
  List<bool>? _isFirst;
  String? selectedMcq;
  OverlayEntry entry = loading();
  List thumb = [
    Color(0xff60E2A3),
    Color(0xff8DC3C1),
    Color(0xffB3AADB),
    Color(0xffE587FD)
  ];
  List<int> time = [];
  late Stopwatch _stopwatch;
  bool bluetext = true;
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
    if (pos != 9) {
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
        List<String> set6Questions = [
          "Over the last two weeks, how often have you been bothered by... Little interest or pleasure in doing things",
          "Over the last two weeks, how often have you been bothered by... Feeling down, depressed, or hopeless",
          "Over the last two weeks, how often have you been bothered by... Trouble falling or staying asleep, or sleeping too much",
          "Over the last two weeks, how often have you been bothered by... Feeling tired or having little energy",
          "Over the last two weeks, how often have you been bothered by... Poor appetite or overeating",
          "Over the last two weeks, how often have you been bothered by... Feeling bad about yourself or that you are a failure or have let yourself or your family down",
          "Over the last two weeks, how often have you been bothered by... Trouble concentrating on things, such as watching television or reading the newspaper",
          "Over the last two weeks, how often have you been bothered by... Moving or speaking so slowly that other people could have noticed. Or being so fidgety or restless that you have been moving around a lot more than usual",
          "Over the last two weeks, how often have you been bothered by... Thoughts that you would be better off dead, or of hurting yourself",
          "If you checked any problems, how difficult have they made it for you to do your work, take care of things at home, or get along with other people?",
        ];
        List<dynamic> answerData = [];
        for (int i = 0; i < 9; i++) {
          // answerData.add(set5SliderText[answers![i]]);
          answerData.add(answers![i] + 1);
        }
        var selectedIndex =
            List<bool>.from(answers![9]).indexWhere((element) => element);
        selectedMcq = buttonQuestionAnswers[selectedIndex];
        answerData.add(selectedMcq);
        print(answerData);
        await Provider.of<Sets>(context, listen: false).addSet(
          3,
          set6Questions,
          answerData,
          time,
        );
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        await overlayPopup(
          'assets/Set3popup.png',
          'You’re Halfway There!',
          'You’re doing so well and now you have only 3 more questionnaires to go. Let’s get going!',
          'KEEP GOING!',
          context,
          1,
        );
        Navigator.popAndPushNamed(context, ScreenNavigationConstant.Set4Screen);
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

  void saveSliderAnswers8(int level) {
    if (set5SliderText[level].length > 0) {
      // setState(() {
      answers![7] = level;
      // });
    }
  }

  void saveSliderAnswers9(int level) {
    if (set5SliderText[level].length > 0) {
      // setState(() {
      answers![8] = level;
      // });
    }
  }

  void saveButtonAnswer(List ans) {
    if (ans.length > 0) {
      answers![9] = ans;
    }
  }

  void bringBlueText() {
    if (pos >= 0 && pos <= 8) {
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
                          color: set3color,
                          height: height * 0.15,
                          padding: EdgeInsets.only(top: height * 0.04),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "Question " + (pos + 1).toString() + "/10",
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
                                  totalSteps: 10,
                                  curStep: pos + 1,
                                  leftColor: Color(0xff5FE3A2),
                                  rightColor: Color(0xffE587FD),
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
                              : checkTablet(height, width)
                                  ? height * 0.53
                                  : height * 0.55,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: 10,
                            physics: new NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return [
                                AnimatedSliders(
                                  answers![0],
                                  3,
                                  '',
                                  'Little interest or pleasure in doing things',
                                  set6SliderImages,
                                  thumb,
                                  set6SliderText,
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
                                  'Feeling down, depressed, or hopeless',
                                  set6SliderImages,
                                  thumb,
                                  set6SliderText,
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
                                  'Trouble falling or staying asleep, or sleeping too much',
                                  set6SliderImages,
                                  thumb,
                                  set6SliderText,
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
                                  'Feeling tired or having little energy',
                                  set6SliderImages,
                                  thumb,
                                  set6SliderText,
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
                                  'Poor appetite or overeating',
                                  set6SliderImages,
                                  thumb,
                                  set6SliderText,
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
                                  'Feeling bad about yourself or that you are a failure or have let yourself or your family down',
                                  set6SliderImages,
                                  thumb,
                                  set6SliderText,
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
                                  'Trouble concentrating on things, such as watching television or reading the newspaper',
                                  set6SliderImages,
                                  thumb,
                                  set6SliderText,
                                  saveSliderAnswers7,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![6],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![7],
                                  3,
                                  '',
                                  'Moving or speaking so slowly that other people could have noticed. Or being so fidgety or restless that you have been moving around a lot more than usual',
                                  set6SliderImages,
                                  thumb,
                                  set6SliderText,
                                  saveSliderAnswers8,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![7],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![8],
                                  3,
                                  '',
                                  'Thoughts that you would be better off dead, or of hurting yourself',
                                  set6SliderImages,
                                  thumb,
                                  set6SliderText,
                                  saveSliderAnswers9,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![8],
                                  changeInitialSlider,
                                  images2,
                                ),
                                ColoredButtonQuestion(
                                  'If you checked any problems, how difficult have they made it for you to do your work, take care of things at home, or get along with other people?',
                                  buttonQuestionColors1,
                                  buttonQuestionAnswers,
                                  changeIsFilled,
                                  saveButtonAnswer,
                                  answers![9],
                                ),
                              ][index % 10];
                            },
                          ),
                        ),
                        //SizedBox(height: height*0.01,),
                        Spacer(),
                        pos == 0
                            ? NavigateButtons(
                                pos != 9 ? 'NEXT' : 'FINISH',
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
                                pos != 9 ? 'NEXT' : 'FINISH',
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
