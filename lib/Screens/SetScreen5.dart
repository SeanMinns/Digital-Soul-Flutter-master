import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/AnimatedSlider1.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/GradientProgressBar.dart';
import 'package:digital_soul/Widgets/MCQWithOther.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/sets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class SetScreen5 extends StatefulWidget {
  const SetScreen5({Key? key}) : super(key: key);

  @override
  _SetScreen5State createState() => _SetScreen5State();
}

class _SetScreen5State extends State<SetScreen5> {
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 800);
  static const _kCurve = Curves.ease;
  int pos = 0;
  bool _isLoading = false;
  List<bool>? _isFilled;
  List<dynamic>? answers;
  List<bool>? _isFirst;
  String? selectedMcq = "";
  OverlayEntry entry = loading();
  List thumb = [
    Color(0xffFCCB8D),
    Color(0xffFCB48B),
    Color(0xffFCA68A),
    Color(0xffFC9288),
    Color(0xffFC8887)
  ];
  List thumb2 = [
    Color(0xffFCCB8D),
    Color(0xffFCCB8D),
    Color(0xffFCB48B),
    Color(0xffFCA68A),
    Color(0xffFC9288),
    Color(0xffFC8887)
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
      [],
      0,
      0,
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
        print("time is " +
            (_stopwatch.elapsedMilliseconds / 1000)
                .toString()); // way to get time
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

  void changeIsFilled(bool value) {
    setState(() {
      _isFilled![pos] = value;
    });
  }

  void nextPage() async {
    if (pos != 11) {
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
        List<String> set4Questions = [
          "How important is spirituality to you?",
          "How important is religion to you?",
          "Do you want to talk about spiritual/ religious issues in treatment?",
          "Do you believe in God/ Higher Power?",
          "Are you active in a faith community or congregation?",
          "Does your spirituality/ religion help you to cope?",
          "Do you feel punished by God/ Higher Power?",
          "Do you question God’s/ Higher Power’s love for you?",
          "Does your spirituality/religion make it harder to cope?",
          "What is your religious affiliation (if any)?",
          "How often do you attend church or other religious services?",
          "How often do you spend time in private religious activities, such as prayer, meditation or Bible study?",
        ];
        List<dynamic> answerData = [];
        for (int i = 0; i < 9; i++) {
          // answerData.add(set4SliderText[answers![i]]);
          answerData.add(answers![i] + 1);
        }
        if (answers![9][answers![9].length - 1] == false) {
          var selectedIndex =
              List<bool>.from(answers![9]).indexWhere((element) => element);
          selectedMcq = mcqQuestions1Set4[selectedIndex];
        }
        answerData.add(selectedMcq);
        for (int i = 10; i < 12; i++) {
          // answerData.add(set4SliderText2[answers![i]]);
          answerData.add(answers![i] + 1);
        }
        print(answerData);
        await Provider.of<Sets>(context, listen: false).addSet(
          5,
          set4Questions,
          answerData,
          time,
        );
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        await overlayPopup(
          'assets/Set5popup.png',
          'One More to Go!',
          'You’re doing so well! One more set to personalize your DigitalSoul!.',
          'KEEP GOING!',
          context,
          0.95,
        );
        Navigator.popAndPushNamed(context, ScreenNavigationConstant.Set6Screen);
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
    if (set4SliderText[level].length > 0) {
      // setState(() {
      answers![0] = level;
      // });
    }
  }

  void saveSliderAnswers2(int level) {
    if (set4SliderText[level].length > 0) {
      // setState(() {
      answers![1] = level;
      // });
    }
  }

  void saveSliderAnswers3(int level) {
    if (set4SliderText[level].length > 0) {
      // setState(() {
      answers![2] = level;
      // });
    }
  }

  void saveSliderAnswers4(int level) {
    if (set4SliderText[level].length > 0) {
      // setState(() {
      answers![3] = level;
      // });
    }
  }

  void saveSliderAnswers5(int level) {
    if (set4SliderText[level].length > 0) {
      // setState(() {
      answers![4] = level;
      // });
    }
  }

  void saveSliderAnswers6(int level) {
    if (set4SliderText[level].length > 0) {
      // setState(() {
      answers![5] = level;
      // });
    }
  }

  void saveSliderAnswers7(int level) {
    if (set4SliderText[level].length > 0) {
      // setState(() {
      answers![6] = level;
      // });
    }
  }

  void saveSliderAnswers8(int level) {
    if (set4SliderText[level].length > 0) {
      // setState(() {
      answers![7] = level;
      // });
    }
  }

  void saveSliderAnswers9(int level) {
    if (set4SliderText[level].length > 0) {
      // setState(() {
      answers![8] = level;
      // });
    }
  }

  void saveSliderAnswers10(int level) {
    if (set4SliderText2[level].length > 0) {
      // setState(() {
      answers![10] = level;
      // });
    }
  }

  void saveSliderAnswers11(int level) {
    if (set4SliderText3[level].length > 0) {
      // setState(() {
      answers![11] = level;
      // });
    }
  }

  void saveMcqAnswers1(List<bool> mcq) {
    // setState(() {
    answers![9] = mcq;
    // });
  }

  void saveOther1(String value) {
    if (answers![9][answers![9].length - 1]) {
      selectedMcq = value;
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
                          color: set5color,
                          height: height * 0.15,
                          padding: EdgeInsets.only(top: height * 0.04),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "Question " + (pos + 1).toString() + "/12",
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
                                  totalSteps: 12,
                                  curStep: pos + 1,
                                  leftColor: Color(0xffFCCC8D),
                                  rightColor: Color(0xffFC8787),
                                  unselectedColor: Color(0xffE5E5E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: height * 0.65,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: 12,
                            physics: new NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return [
                                AnimatedSliders1(
                                  answers![0],
                                  4,
                                  '',
                                  'How important is spirituality to you?',
                                  set4SliderImages,
                                  thumb,
                                  set4SliderText,
                                  saveSliderAnswers1,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![0],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders1(
                                  answers![1],
                                  4,
                                  '',
                                  'How important is religion to you? ',
                                  set4SliderImages,
                                  thumb,
                                  set4SliderText,
                                  saveSliderAnswers2,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![1],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders1(
                                  answers![2],
                                  4,
                                  '',
                                  'Do you want to talk about spiritual/religious issues in treatment? ',
                                  set4SliderImages,
                                  thumb,
                                  set4SliderText,
                                  saveSliderAnswers3,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![2],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders1(
                                  answers![3],
                                  4,
                                  '',
                                  'Do you believe in God/Higher Power?',
                                  set4SliderImages,
                                  thumb,
                                  set4SliderText,
                                  saveSliderAnswers4,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![3],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders1(
                                  answers![4],
                                  4,
                                  '',
                                  'Are you active in a faith community or congregation? ',
                                  set4SliderImages,
                                  thumb,
                                  set4SliderText,
                                  saveSliderAnswers5,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![4],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders1(
                                  answers![5],
                                  4,
                                  '',
                                  'Does your spirituality/religion help you to cope? ',
                                  set4SliderImages,
                                  thumb,
                                  set4SliderText,
                                  saveSliderAnswers6,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![5],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders1(
                                  answers![6],
                                  4,
                                  '',
                                  'Do you feel punished by God/Higher Power?',
                                  set4SliderImages,
                                  thumb,
                                  set4SliderText,
                                  saveSliderAnswers7,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![6],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders1(
                                  answers![7],
                                  4,
                                  '',
                                  'Do you question God’s/Higher Power’s love for you? ',
                                  set4SliderImages,
                                  thumb,
                                  set4SliderText,
                                  saveSliderAnswers8,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![7],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders1(
                                  answers![8],
                                  4,
                                  '',
                                  'Does your spirituality/religion make it harder to cope? ',
                                  set4SliderImages,
                                  thumb,
                                  set4SliderText,
                                  saveSliderAnswers9,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![8],
                                  changeInitialSlider,
                                  images2,
                                ),
                                MCQWithOther(
                                  selectedMcq!,
                                  saveOther1,
                                  mcqQuestions1Set4,
                                  'What is your religious affiliation (if any)?                              ',
                                  changeIsFilled,
                                  List<bool>.from(answers![9]),
                                  saveMcqAnswers1,
                                ),
                                AnimatedSliders1(
                                  answers![10],
                                  5,
                                  '',
                                  'How often do you attend church or other religious services? ',
                                  set4SliderImages2,
                                  thumb2,
                                  set4SliderText2,
                                  saveSliderAnswers10,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![10],
                                  changeInitialSlider,
                                  images2,
                                ),
                                AnimatedSliders1(
                                  answers![11],
                                  5,
                                  '',
                                  'How often do you spend time in private religious activities, such as prayer, meditation or Bible study?',
                                  set4SliderImages2,
                                  thumb2,
                                  set4SliderText3,
                                  saveSliderAnswers11,
                                  changeIsFilled,
                                  nextPage,
                                  _isFirst![11],
                                  changeInitialSlider,
                                  images2,
                                ),
                              ][index % 12];
                            },
                          ),
                        ),
                        //SizedBox(height: height*0.01,),
                        pos == 0
                            ? NavigateButtons(
                                pos != 11 ? 'NEXT' : 'FINISH',
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
                                pos != 11 ? 'NEXT' : 'FINISH',
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
