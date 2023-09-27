import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/DropDown.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/GradientProgressBar.dart';
import 'package:digital_soul/Widgets/MCQ.dart';
import 'package:digital_soul/Widgets/MCQWithOther.dart';
import 'package:digital_soul/Widgets/MCQWithOtherLayout.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/sets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Set1Screen extends StatefulWidget {
  const Set1Screen({Key? key}) : super(key: key);

  @override
  _Set1ScreenState createState() => _Set1ScreenState();
}

class _Set1ScreenState extends State<Set1Screen> {
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 800);
  static const _kCurve = Curves.ease;
  int pos = 0;
  bool _isLoading = false;
  List<bool>? _isFilled;
  List<dynamic>? answers;
  String? selectedMcq1 = "";
  String? selectedMcq2 = "";
  String? selectedMcq3 = "";
  String? selectedMcq4 = "";
  OverlayEntry entry = loading();

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
    ];
    time = [
      0,
      0,
      0,
      0,
      0,
    ];
    answers = [
      0,
      [],
      [],
      [],
      [],
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
  }

  void changeIsFilled(bool value) {
    setState(() {
      _isFilled![pos] = value;
    });
  }

  void nextPage() async {
    if (pos != 4) {
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
        List<String> set1Questions = [
          "How old are you?",
          "How do you describe yourself? (please pick one)",
          "What sex were you assigned at birth, such as on an original birth certificate?",
          "Do you consider yourself to be-",
          "Which category best describes you? (You may select more than one)",
        ];
        if (answers![1][answers![1].length - 1] == false) {
          var selectedIndex =
              List<bool>.from(answers![1]).indexWhere((element) => element);
          selectedMcq1 = mcqQuestions1Set1[selectedIndex];
        }
        var selectedIndex =
            List<bool>.from(answers![2]).indexWhere((element) => element);
        selectedMcq2 = mcqQuestions2Set1[selectedIndex];
        if (answers![3][answers![3].length - 1] == false) {
          var selectedIndex =
              List<bool>.from(answers![3]).indexWhere((element) => element);
          selectedMcq3 = mcqQuestions3Set1[selectedIndex];
        }
        if (answers![4][answers![4].length - 1] == false) {
          var selectedIndex =
              List<bool>.from(answers![4]).indexWhere((element) => element);
          selectedMcq4 = mcqQuestions4Set1[selectedIndex];
        }
        List<dynamic> answerData = [
          answers![0],
          selectedMcq1,
          selectedMcq2,
          selectedMcq3,
          selectedMcq4,
        ];
        print(answerData);
        await Provider.of<Sets>(context, listen: false).addSet(
          1,
          set1Questions,
          answerData,
          time,
        );
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        await overlayPopup(
          'assets/Set1popup.png',
          'Well Done!',
          'You’re one down and just need to finish 5 more questionnaires.',
          'Let\'s Get to It!',
          context,
          0.95,
        );
        Navigator.popAndPushNamed(
            context, ScreenNavigationConstant.Instruction);
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

  void saveDropDownAnswers(String answer) {
    // setState(() {
    answers![0] = int.parse(answer);
    // });
  }

  void saveMcqAnswers1(List<bool> mcq) {
    // setState(() {
    answers![1] = mcq;
    print(answers![1]);
    // });
  }

  void saveOther1(String value) {
    if (answers![1][answers![1].length - 1]) {
      selectedMcq1 = value;
    }
  }

  void saveMcqAnswers2(List<bool> mcq) {
    // setState(() {
    answers![2] = mcq;
    // });
  }

  void saveMcqAnswers3(List<bool> mcq) {
    setState(() {
      answers![3] = mcq;
    });
  }

  void saveOther3(String value) {
    if (answers![3][answers![3].length - 1]) {
      selectedMcq3 = value;
    }
  }

  void saveMcqAnswers4(List<bool> mcq) {
    // setState(() {
    answers![4] = mcq;
    // });
  }

  void saveOther4(String value) {
    print(value);
    if (answers![4][answers![4].length - 1]) {
      selectedMcq4 = value;
    }
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
                          color: set1,
                          height: height * 0.15,
                          padding: EdgeInsets.only(top: height * 0.04),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "Question " + (pos + 1).toString() + "/5",
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
                                  totalSteps: 5,
                                  curStep: pos + 1,
                                  leftColor: Color(0xffE587FD),
                                  rightColor: Color(0xff87C3FF),
                                  unselectedColor: Color(0xffE5E5E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(top: height * 0.015),
                          height: height * 0.63,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: 5,
                            physics: new NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return [
                                DropDown(
                                  answers![0].toString(),
                                  ageQuestion,
                                  '',
                                  'How old are you?',
                                  changeIsFilled,
                                  saveDropDownAnswers,
                                  true,
                                ),
                                MCQWithOther(
                                  selectedMcq1!,
                                  saveOther1,
                                  mcqQuestions1Set1,
                                  'How do you describe yourself? (please pick one)',
                                  changeIsFilled,
                                  List<bool>.from(answers![1]),
                                  saveMcqAnswers1,
                                ),
                                MCQ(
                                    1,
                                    mcqQuestions2Set1,
                                    'What sex were you assigned at birth, such as on an original birth certificate?',
                                    "",
                                    "",
                                    List<bool>.from(answers![2]),
                                    changeIsFilled,
                                    saveMcqAnswers2,
                                    true,
                                    1,
                                    0.025),
                                MCQWithOther(
                                  selectedMcq3!,
                                  saveOther3,
                                  mcqQuestions3Set1,
                                  'Do you consider yourself to be -',
                                  changeIsFilled,
                                  List<bool>.from(answers![3]),
                                  saveMcqAnswers3,
                                ),
                                MCQWithOtherLayout(
                                  selectedMcq4!,
                                  saveOther4,
                                  mcqQuestions4Set1,
                                  'Which category best describes you? (You may select more than one)',
                                  changeIsFilled,
                                  List<bool>.from(answers![4]),
                                  saveMcqAnswers4,
                                ),
                              ][index % 5];
                            },
                          ),
                        ),
                        //SizedBox(height: height*0.01,),
                        pos == 0
                            ? NavigateButtons(
                                pos != 4 ? 'NEXT' : 'FINISH',
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
                                pos != 4 ? 'NEXT' : 'FINISH',
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
