import 'dart:typed_data';
import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:digital_soul/Widgets/AnimatedSliders.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/GradientProgressBar.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/profile.dart';
import 'package:digital_soul/providers/sets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class SetScreen6 extends StatefulWidget {
  const SetScreen6({Key? key}) : super(key: key);

  @override
  _SetScreen6State createState() => _SetScreen6State();
}

class _SetScreen6State extends State<SetScreen6> {
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 800);
  static const _kCurve = Curves.ease;
  int pos = 0;
  bool _isLoading = false;
  List<bool>? _isFilled;
  List<dynamic>? answers;
  List<bool>? _isFirst;
  OverlayEntry entry = loading();
  List thumb = [
    Color(0xff87C3FF),
    Color(0xffB0A8E1),
    Color(0xffD88DC4),
    Color(0xffF878AC)
  ];
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
    done = await loadImage(thumbBlue[0]);
    if (done) {
      done = await loadImage(thumbBlue[1]);
      if (done == false) {
        print("error");
      }
    } else {
      print("error");
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
      0,
      0,
      0,
      0,
      0,
    ];

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
  }

  void changeIsFilled(bool value) async {
    setState(() {
      _isFilled![pos] = value;
    });
  }

  void nextPage() async {
    if (pos != 13) {
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
        List<String> set2Questions = [
          "How much or how frequently have you...Looked for a stronger connection with God.",
          "How much or how frequently have you...Sought God’s love and care.",
          "How much or how frequently have you...Sought help from God in letting go of my anger.",
          "How much or how frequently have you...Tried to put my plans into action together with God.",
          "How much or how frequently have you...Sought help from God in letting go of my anger.",
          "How much or how frequently have you...Asked forgiveness for my sins.",
          "How much or how frequently have you...Focused on religion to stop worrying about my problems.",
          "How much or how frequently have you...Wondered whether God had abandoned me.",
          "How much or how frequently have you...Felt punished by God for my lack of devotion.",
          "How much or how frequently have you...Wondered what I did for God to punish me.",
          "How much or how frequently have you...Questioned God’s love for me.",
          "How much or how frequently have you...Wondered whether my church had abandoned me.",
          "How much or how frequently have you...How much or how frequently have you...",
          "How much or how frequently have you...Questioned the power of God.",
        ];
        List<dynamic> answerData = [];
        for (int i = 0; i < answers!.length; i++) {
          // answerData.add(set2SliderText[answers![i]]);
          answerData.add(answers![i] + 1);
        }
        print(answerData);
        await Provider.of<Sets>(context, listen: false).addSet(
          6,
          set2Questions,
          answerData,
          time,
        );
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        Profile? profile =
            Provider.of<UserProfile>(context, listen: false).item;
        await overlayPopup(
          'assets/Set6popup.png',
          'And You’re Done, ${profile!.firstName}',
          'Thank you for taking the time to answer these. Now you can begin with a lesson or the prayer diary.',
          'HomeScreen',
          context,
          0.95,
        );
        List<int> data = [];
        Navigator.popAndPushNamed(context, ScreenNavigationConstant.homeScreen,
            arguments: {
              "progress": data,
            });
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
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![0] = level;
      // });
    }
  }

  void saveSliderAnswers2(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![1] = level;
      // });
    }
  }

  void saveSliderAnswers3(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![2] = level;
      // });
    }
  }

  void saveSliderAnswers4(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![3] = level;
      // });
    }
  }

  void saveSliderAnswers5(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![4] = level;
      // });
    }
  }

  void saveSliderAnswers6(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![5] = level;
      // });
    }
  }

  void saveSliderAnswers7(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![6] = level;
      // });
    }
  }

  void saveSliderAnswers8(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![7] = level;
      // });
    }
  }

  void saveSliderAnswers9(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![8] = level;
      // });
    }
  }

  void saveSliderAnswers10(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![9] = level;
      // });
    }
  }

  void saveSliderAnswers11(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![10] = level;
      // });
    }
  }

  void saveSliderAnswers12(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![11] = level;
      // });
    }
  }

  void saveSliderAnswers13(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![12] = level;
      // });
    }
  }

  void saveSliderAnswers14(int level) {
    if (set2SliderText[level].length > 0) {
      // setState(() {
      answers![13] = level;
      // });
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
                          color: set6color,
                          height: height * 0.15,
                          padding: EdgeInsets.only(top: height * 0.04),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "Question " + (pos + 1).toString() + "/14",
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
                                  totalSteps: 14,
                                  curStep: pos + 1,
                                  leftColor: Color(0xff87C3FF),
                                  rightColor: Color(0xffF878AC),
                                  unselectedColor: Color(0xffE5E5E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: height * 0.02,
                            left: width * 0.03,
                          ),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'How much or how frequently have you...',
                            style: styles.getBlueQuestionTextStyle(),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: checkTablet(height, width)
                              ? height * 0.53
                              : height * 0.55,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: 14,
                            physics: new NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return [
                                AnimatedSliders(
                                  answers![0],
                                  3,
                                  '',
                                  'Looked for a stronger connection with God.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
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
                                  'Sought God’s love and care.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
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
                                  'Sought help from God in letting go of my anger.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
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
                                  'Tried to put my plans into action together with God.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
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
                                  'Sought help from God in letting go of my anger.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
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
                                  'Asked forgiveness for my sins.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
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
                                  'Focused on religion to stop worrying about my problems.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
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
                                  'Wondered whether God had abandoned me.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
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
                                  'Felt punished by God for my lack of devotion.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
                                  saveSliderAnswers9,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![8],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![9],
                                  3,
                                  '',
                                  'Wondered what I did for God to punish me.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
                                  saveSliderAnswers10,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![9],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![10],
                                  3,
                                  '',
                                  'Questioned God’s love for me.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
                                  saveSliderAnswers11,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![10],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![11],
                                  3,
                                  '',
                                  'Wondered whether my church had abandoned me.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
                                  saveSliderAnswers12,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![11],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![12],
                                  3,
                                  '',
                                  'Decided the devil made this happen.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
                                  saveSliderAnswers13,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![12],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders(
                                  answers![13],
                                  3,
                                  '',
                                  'Questioned the power of God.',
                                  set2SliderImages,
                                  thumb,
                                  set2SliderText,
                                  saveSliderAnswers14,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![13],
                                  changeInitialSlider,
                                  images2,
                                ),
                              ][index % 14];
                            },
                          ),
                        ),
                        //SizedBox(height: height*0.01,),
                        Spacer(),
                        pos == 0
                            ? NavigateButtons(
                                pos != 13 ? 'NEXT' : 'FINISH',
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
                                pos != 13 ? 'NEXT' : 'FINISH',
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
