import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/DropDown.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/GradientProgressBar.dart';
import 'package:digital_soul/Widgets/YesOrNoType.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/sets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Constants/Text_Styles.dart';

class SetScreen4 extends StatefulWidget {
  const SetScreen4({Key? key}) : super(key: key);

  @override
  _SetScreen4State createState() => _SetScreen4State();
}

class _SetScreen4State extends State<SetScreen4> {
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 800);
  static const _kCurve = Curves.ease;
  int pos = 0;
  bool _isLoading = false;
  List<bool>? _isFilled;
  List<dynamic>? answers;
  OverlayEntry entry = loading();
  bool bluetext = true;
  List<int> time = [];
  late Stopwatch _stopwatch;

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
    ];
    answers = [
      0,
      0,
      0,
      '',
      '',
      '',
      '',
      '',
      '',
    ];

    _stopwatch = Stopwatch();
    handleStartStop(0, pos);
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
    if (pos >= 3 && pos <= 8) {
      nextPage();
    }
  }

  void nextPage() async {
    if (pos != 8) {
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
        List<String> set3Questions = [
          "During the last 12 months, how many days did you Drink more than a few sips of beer, wine, or any drink containing alcohol? Put “0” if none.",
          "During the last 12 months, how many days did you Use any marijuana (weed, oil, or hash, by smoking, vaping, or in food) or “synthetic marijuana” (like “K2,” “Spice”) or “vaping” THC oil? Put “0” if none.",
          "During the last 12 months, how many days did you Use anything else to get high (like other illegal drugs, prescription or over-the-counter medications, and things that you sniff, huff, or vape )? Put “0” if none.",
          "Have you ever ridden in a CAR driven by someone (including yourself) who was “high” or had been using alcohol or drugs?",
          "Do you ever use alcohol or drugs to RELAX, feel better about yourself,or fit in?",
          "Do you ever use alcohol or drugs while you are by yourself, or ALONE?",
          "Do you ever FORGET things you did while using alcohol or drugs?",
          "Do your FAMILY or FRIENDS ever tell you that you should cut down on your drinking or drug use?",
          "Have you ever gotten into any TROUBLE while you were using alcohol or drugs?",
        ];
        print(answers);
        await Provider.of<Sets>(context, listen: false).addSet(
          4,
          set3Questions,
          answers!,
          time,
        );
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        await overlayPopup(
          'assets/Set4popup.png',
          'Almost There!',
          'Well done, you’re left with only 2 questionnaires now. Let’s do this!',
          'KEEP GOING!',
          context,
          0.95,
        );
        Navigator.popAndPushNamed(context, ScreenNavigationConstant.Set5Screen);
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
    if (pos >= 0 && pos <= 2) {
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

  void saveDropDownAnswers1(String answer) {
    // setState(() {
    answers![0] = int.parse(answer);
    // });
  }

  void saveDropDownAnswers2(String answer) {
    // setState(() {
    answers![1] = int.parse(answer);
    // });
  }

  void saveDropDownAnswers3(String answer) {
    // setState(() {
    answers![2] = int.parse(answer);
    // });
  }

  void saveYesOrNo1(String value) {
    answers![3] = value;
  }

  void saveYesOrNo2(String value) {
    answers![4] = value;
  }

  void saveYesOrNo3(String value) {
    answers![5] = value;
  }

  void saveYesOrNo4(String value) {
    answers![6] = value;
  }

  void saveYesOrNo5(String value) {
    answers![7] = value;
  }

  void saveYesOrNo6(String value) {
    answers![8] = value;
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
                          color: set4color,
                          height: height * 0.15,
                          padding: EdgeInsets.only(top: height * 0.04),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "Question " + (pos + 1).toString() + "/9",
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
                                  totalSteps: 9,
                                  curStep: pos + 1,
                                  leftColor: Color(0xffF878AC),
                                  rightColor: Color(0xffFCCC8D),
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
                                  left: width * 0.06,
                                  right: width * 0.06,
                                ),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'During the last 12 months, how many days did you',
                                  style: styles.getBlueQuestionTextStyle(),
                                ),
                              )
                            : Container(),
                        Container(
                          color: Colors.white,
                          height: bluetext == false
                              ? height * 0.65
                              : height >= 1000
                                  ? height * 0.55
                                  : height * 0.5,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: 9,
                            physics: new NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return [
                                DropDown(
                                  answers![0].toString(),
                                  dropDownSet3,
                                  '',
                                  'Drink more than a few sips of beer, wine, or any drink containing alcohol? Put “0” if none.',
                                  changeIsFilled,
                                  saveDropDownAnswers1,
                                  true,
                                ),
                                DropDown(
                                  answers![1].toString(),
                                  dropDownSet3,
                                  '',
                                  'Use any marijuana (weed, oil, or hash, by smoking, vaping, or in food) or “synthetic marijuana” (like “K2,” “Spice”) or “vaping” THC oil? Put “0” if none.',
                                  changeIsFilled,
                                  saveDropDownAnswers2,
                                  true,
                                ),
                                DropDown(
                                  answers![2].toString(),
                                  dropDownSet3,
                                  '',
                                  'Use anything else to get high (like other illegal drugs, prescription or over-the-counter medications, and things that you sniff, huff, or vape)? Put “0” if none.',
                                  changeIsFilled,
                                  saveDropDownAnswers3,
                                  true,
                                ),
                                YesOrNoType(
                                  answers![3],
                                  '',
                                  'Have you ever ridden in a CAR driven by someone (including yourself) who was “high” or had been using alcohol or drugs?',
                                  changeIsFilled,
                                  saveYesOrNo1,
                                ),
                                YesOrNoType(
                                  answers![4],
                                  '',
                                  'Do you ever use alcohol or drugs to RELAX, feel better about yourself, or fit in?',
                                  changeIsFilled,
                                  saveYesOrNo2,
                                ),
                                YesOrNoType(
                                  answers![5],
                                  '',
                                  'Do you ever use alcohol or drugs while you are by yourself, or ALONE?',
                                  changeIsFilled,
                                  saveYesOrNo3,
                                ),
                                YesOrNoType(
                                  answers![6],
                                  '',
                                  'Do you ever FORGET things you did while using alcohol or drugs?',
                                  changeIsFilled,
                                  saveYesOrNo4,
                                ),
                                YesOrNoType(
                                  answers![7],
                                  '',
                                  'Do your FAMILY or FRIENDS ever tell you that you should cut down on your drinking or drug use?',
                                  changeIsFilled,
                                  saveYesOrNo5,
                                ),
                                YesOrNoType(
                                  answers![8],
                                  '',
                                  'Have you ever gotten into any TROUBLE while you were using alcohol or drugs?',
                                  changeIsFilled,
                                  saveYesOrNo6,
                                ),
                              ][index % 9];
                            },
                          ),
                        ),
                        //SizedBox(height: height*0.01,),
                        Spacer(),
                        pos == 0
                            ? NavigateButtons(
                                pos != 8 ? 'NEXT' : 'FINISH',
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
                                pos != 8 ? 'NEXT' : 'FINISH',
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
