import 'dart:convert';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/FreeResponse.dart';
import 'package:digital_soul/Widgets/GradientProgressBar.dart';
import 'package:digital_soul/Widgets/MCQ.dart';
import 'package:digital_soul/Widgets/SliderQuestion.dart';
import 'package:digital_soul/Widgets/VideoWidget.dart';
import 'package:digital_soul/Widgets/YesOrNoType.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/database_helper.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:digital_soul/providers/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Lesson4Screen extends StatefulWidget {
  const Lesson4Screen({Key? key}) : super(key: key);

  @override
  _Lesson4ScreenState createState() => _Lesson4ScreenState();
}

class _Lesson4ScreenState extends State<Lesson4Screen> {
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 600);
  static const _kCurve = Curves.ease;
  int pos = 0;
  bool _isLoading = false;
  bool _isInit = true;
  List<bool>? _isFilled;
  List<dynamic>? answers;
  bool? showPopup;

  // String? selectedMcq1;
  GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  Icon icon = Icon(Icons.more_horiz);
  OverlayEntry entry = loading();
  bool bluetext = false;
  List<int> time = [];
  late Stopwatch _stopwatch;
  List<bool> isIntialChanged = [false, false];
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
    if (isMenuOpen) _overlayEntry!.remove();
    //_animationController.dispose();
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    }
    entry.dispose();
    super.dispose();
  }

  findButton() {
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry!.remove();
    icon = Icon(Icons.more_horiz);
    //  _animationController.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    //   _animationController.forward();
    icon = Icon(Icons.close);
    _overlayEntry = moreOverlay(buttonPosition, buttonSize, true, 3, () {
      setState(() {
        closeMenu();
      });
    }, context);
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  void initState() {
    _key = LabeledGlobalKey("button_icon");
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
      0,
      0,
      0,
    ];
    answers = [
      [0, 0],
      '',
      '-VIDEO-',
      [],
      [],
      [],
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      [0, 0],
    ];
    // selectedMcq1 = '';
    showPopup = true;
    _stopwatch = Stopwatch();
    handleStartStop(0, pos);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      if (data['answers'].length != 0) {
        for (int i = 0; i < data['answers'].length; i++) {
          _isFilled![i] = true;
          time[i] = data['timer'][i];
          if (i == 0 || i == 3 || i == 4 || i == 5 || i == 16) {
            answers![i] = json.decode(data['answers'][i]);
          } else {
            answers![i] = data['answers'][i];
          }
        }
      }
      _isInit = false;
    }
    if (_isFilled![0]) {
      isIntialChanged[0] = true;
    }
    if (_isFilled![_isFilled!.length - 1]) {
      isIntialChanged[1] = true;
    }
    super.didChangeDependencies();
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
    if (pos >= 7 && pos <= 14) {
      nextPage();
    }
  }

  void nextPage() async {
    // var allData = await DatabaseHelper.instance.deleteAll();
    if (pos != 16) {
      handleStartStop(0, pos);
      var profileId = Provider.of<UserProfile>(context, listen: false).item!.id;
      print(profileId);
      var getData =
          await DatabaseHelper.instance.querySome(profileId!, 4, pos + 1);
      print(getData);
      if (getData.length == 0) {
        var insertData = await DatabaseHelper.instance.insert({
          DatabaseHelper.userId: '$profileId',
          DatabaseHelper.lessonNo: 4,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(insertData);
        Provider.of<Lessons>(context, listen: false).addQuestion(
          3,
          '${answers![pos]}',
          time[pos],
        );
      } else {
        var updateData = await DatabaseHelper.instance.update({
          DatabaseHelper.columnId: getData[0]['_id'],
          DatabaseHelper.userId: profileId,
          DatabaseHelper.lessonNo: 4,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(updateData);
        Provider.of<Lessons>(context, listen: false).updateQuestion(
          3,
          pos,
          '${answers![pos]}',
          time[pos],
        );
      }
      var allData = await DatabaseHelper.instance.queryAll();
      print(allData);
      changePos(pos + 1);
      _controller.nextPage(duration: _kDuration, curve: _kCurve);
      if (pos == 3 && showPopup!) {
        overlayPopup(
          'assets/LessonPopup1.png',
          'You\'re Doing So Well!',
          'Now that you have seen the lesson video, let’s go through some exercises to understand your needs better.',
          'KEEP GOING!',
          context,
          1,
        );
        showPopup = false;
      }
    } else {
      handleStartStop(1, pos);
      setState(() {
        if (isMenuOpen) closeMenu();
      });
      try {
        setState(() {
          _isLoading = true;
        });
        showOverlay(false, context);
        List<String> lesson4Questions = [
          "How would you rate your mood right now?",
          "Can you tell us why you picked this lesson?",
          "Please watch this lesson video. ",
          "There are many types of prayer. Which of these did you do last week?",
          "There are many ways to pray. Which of these did you do last week?",
          "Do you pray in times of Joy? Sadness? Anxiety? Pain? Select all that apply",
          "When you pray...What happens to your mental health?",
          "Does praying make you feel more...Anxious and obsessed",
          "Does praying make you feel more...Hopeless or depressed",
          "Does praying make you feel more...Ashamed or guilty?",
          "Does praying make you feel more...Disconnected from reality?",
          "Does praying make you feel more...Focused and alert?",
          "Does praying make you feel more...Meaningful and purposeful?",
          "Does praying make you feel more...Calm and peaceful?",
          "Does praying make you feel more...Happy and hopeful?",
          "Having gone through this module, are there better ways you can use prayer to cope with your mental health (e.g., what you pray for, and when/how you pray)?",
          "You did it! How do you feel after this lesson?",
        ];
        List<String> mcq1 = [];
        List<String> mcq2 = [];
        List<String> mcq3 = [];
        for (int i = 0; i < mcqQuestions1Lesson4.length; i++) {
          if (answers![3][i]) {
            mcq1.add(mcqQuestions1Lesson4[i]);
          }
        }
        for (int i = 0; i < mcqQuestions2Lesson4.length; i++) {
          if (answers![4][i]) {
            mcq2.add(mcqQuestions2Lesson4[i]);
          }
        }
        for (int i = 0; i < mcqQuestions3Lesson4.length; i++) {
          if (answers![5][i]) {
            mcq3.add(mcqQuestions3Lesson4[i]);
          }
        }
        String answer3 = mcq1.join(', ');
        String answer4 = mcq2.join(', ');
        String answer5 = mcq3.join(', ');
        List<dynamic> answerData = [
          "${emotionText[answers![0][0]]}, ${stressText[answers![0][1]]}",
          answers![1],
          answers![2],
          answer3,
          answer4,
          answer5,
          answers![6],
          answers![7],
          answers![8],
          answers![9],
          answers![10],
          answers![11],
          answers![12],
          answers![13],
          answers![14],
          answers![15],
          "${emotionText[answers![16][0]]}, ${stressText[answers![16][1]]}",
        ];
        print(answerData);
        var profile = Provider.of<UserProfile>(context, listen: false).item;
        var keyWords1 = suicidalWords
            .where((word) => answers![1].toString().contains(word))
            .toList();
        var keyWords2 = suicidalWords
            .where((word) => answers![6].toString().contains(word))
            .toList();
        var keyWords3 = suicidalWords
            .where((word) => answers![15].toString().contains(word))
            .toList();
        var finalKeyWords =
            [...keyWords1, ...keyWords2, ...keyWords3].toSet().toList();
        await Provider.of<Lessons>(context, listen: false)
            .addLesson("4", lesson4Questions, answerData, time);
        Provider.of<Lessons>(context, listen: false).addProgress(4);
        var profileId =
            Provider.of<UserProfile>(context, listen: false).item!.id;
        var deletedData =
            await DatabaseHelper.instance.deleteLesson(profileId!, 4);
        print(deletedData);
        Provider.of<Lessons>(context, listen: false).deleteLesson(3);
        if (finalKeyWords.length != 0) {
          print("suicidal mail sent");
          var message = "UserId: ${profile!.id}, KeyWordsUsed: $finalKeyWords";
          await Provider.of<Lessons>(context, listen: false)
              .sendEmailToChaplain(
            profile.id!,
            profile.email!,
            message,
          );
          await Provider.of<Lessons>(context, listen: false)
              .addSuicideWords(finalKeyWords, 'lesson4');
        }
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        Navigator.of(context).popAndPushNamed(
          ScreenNavigationConstant.PopupLessonScreen,
          arguments: {
            'route': 'assets/Lesson4Popup2.png',
            'color': lesson4,
            'number': '4',
          },
        );
      } on HttpException catch (error) {
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
        if (error.toString() != 'Failed to add lesson 4') {
          Navigator.of(context).popAndPushNamed(
            ScreenNavigationConstant.PopupLessonScreen,
            arguments: {
              'route': 'assets/Lesson4Popup2.png',
              'color': lesson4,
            },
          );
        }
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

  void prevPage() async {
    if (_isFilled![pos]) {
      handleStartStop(0, pos);
      var profileId = Provider.of<UserProfile>(context, listen: false).item!.id;
      print(profileId);
      var getData =
          await DatabaseHelper.instance.querySome(profileId!, 4, pos + 1);
      print(getData);
      if (getData.length == 0) {
        var insertData = await DatabaseHelper.instance.insert({
          DatabaseHelper.userId: '$profileId',
          DatabaseHelper.lessonNo: 4,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(insertData);
        Provider.of<Lessons>(context, listen: false).addQuestion(
          3,
          '${answers![pos]}',
          time[pos],
        );
      } else {
        var updateData = await DatabaseHelper.instance.update({
          DatabaseHelper.columnId: getData[0]['_id'],
          DatabaseHelper.userId: profileId,
          DatabaseHelper.lessonNo: 4,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(updateData);
        Provider.of<Lessons>(context, listen: false).updateQuestion(
          3,
          pos,
          '${answers![pos]}',
          time[pos],
        );
      }
      var allData = await DatabaseHelper.instance.queryAll();
      print(allData);
    }
    if (pos != 0) {
      changePos(pos - 1);
      _controller.previousPage(
        duration: _kDuration,
        curve: _kCurve,
      );
    } else {
      handleStartStop(1, pos);
      setState(() {
        if (isMenuOpen) closeMenu();
      });
      Navigator.of(context).pop();
    }
  }

  void saveSliderAnswers(
    int type,
    int emotions,
    int stress,
  ) {
    if (type == 1) {
      if (emotionText[emotions].length > 0) {
        // setState(() {
        answers![0][0] = emotions;
        // });
      }
      if (stressText[stress].length > 0) {
        // setState(() {
        answers![0][1] = stress;
        // });
      }
    } else {
      if (emotionText[emotions].length > 0) {
        // setState(() {
        answers![16][0] = emotions;
        // });
      }
      if (stressText[stress].length > 0) {
        // setState(() {
        answers![16][1] = stress;
        // });
      }
    }
  }

  void bringBlueText() {
    if (pos >= 7 && pos <= 14) {
      if (bluetext == false) {
        if (pos != 14) {
          setState(() {
            bluetext = true;
          });
        }
        if (pos == 14) {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              bluetext = true;
            });
          });
        }
      }
    } else {
      if (bluetext == true) {
        setState(() {
          bluetext = false;
        });
      }
    }
  }

  void saveFreeResponseAnswer1(String value) {
    answers![1] = value;
  }

  void saveFreeResponseAnswer2(String value) {
    answers![6] = value;
  }

  void saveFreeResponseAnswer3(String value) {
    answers![15] = value;
  }

  void saveMcqAnswers1(List<bool> mcq) {
    // setState(() {
    answers![3] = mcq;
    // var selectedIndex = mcq.indexWhere((element) => element);
    // selectedMcq1 = mcqQuestionsLesson1[selectedIndex];
    // });
  }

  void saveMcqAnswers2(List<bool> mcq) {
    // setState(() {
    answers![4] = mcq;
    // var selectedIndex = mcq.indexWhere((element) => element);
    // selectedMcq1 = mcqQuestionsLesson1[selectedIndex];
    // });
  }

  void saveMcqAnswers3(List<bool> mcq) {
    // setState(() {
    answers![5] = mcq;
    // var selectedIndex = mcq.indexWhere((element) => element);
    // selectedMcq1 = mcqQuestionsLesson1[selectedIndex];
    // });
  }

  void saveYesOrNo1(String value) {
    answers![7] = value;
  }

  void saveYesOrNo2(String value) {
    answers![8] = value;
  }

  void saveYesOrNo3(String value) {
    answers![9] = value;
  }

  void saveYesOrNo4(String value) {
    answers![10] = value;
  }

  void saveYesOrNo5(String value) {
    answers![11] = value;
  }

  void saveYesOrNo6(String value) {
    answers![12] = value;
  }

  void saveYesOrNo7(String value) {
    answers![13] = value;
  }

  void saveYesOrNo8(String value) {
    answers![14] = value;
  }

  void changeInitialSlider(bool value) {
    setState(() {
      isIntialChanged[pos % (_isFilled!.length - 2)] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    print("Height: " + height.toString());
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
                    color: backGround,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          color: lesson4,
                          height: height * 0.2,
                          child: Column(
                            children: [
                              Container(
                                key: _key,
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(
                                  right: width * 0.02,
                                ),
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Image.asset('assets/hamburger.png'),
                                  onPressed: () {
                                    setState(() {
                                      if (isMenuOpen) {
                                        closeMenu();
                                      } else {
                                        openMenu();
                                      }
                                    });
                                  },
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Lesson 4",
                                  style: styles.getBlackHeading(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "THE POWER OF PRAYER",
                                  style: styles.getSmallHeadingTextStyle(),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  width * 0.05,
                                  height * 0.03,
                                  width * 0.05,
                                  0,
                                ),
                                child: GradientProgressBar(
                                  size: 10,
                                  totalSteps: 17,
                                  curStep: pos + 1,
                                  leftColor: lesson4ProgresLeft,
                                  rightColor: lesson4ProgresRight,
                                  unselectedColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        bluetext
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: height * 0.02, left: width * 0.03),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Does praying make you feel more...',
                                  style: styles.getBlueQuestionTextStyle(),
                                ),
                              )
                            : Container(),
                        Container(
                          color: backGround,
                          height:
                              bluetext == false ? height * 0.6 : height * 0.5,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: 17,
                            physics: new NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return [
                                SliderQuestion(
                                  "How would you rate your mood right now?",
                                  1,
                                  answers![0][0]!.toDouble(),
                                  answers![0][1]!.toDouble(),
                                  saveSliderAnswers,
                                  changeIsFilled,
                                  height,
                                  width,
                                  changeInitialSlider,
                                  isIntialChanged[0],
                                ),
                                FreeResponse(
                                  answers![1],
                                  '',
                                  'Can you tell us why you picked this lesson?',
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  changeIsFilled,
                                  saveFreeResponseAnswer1,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(height * 0.03),
                                      child: Text(
                                        'Please watch this lesson video',
                                        style:
                                            styles.getNormalHeadingTextStyle(),
                                      ),
                                    ),
                                    VideoWidget(height * 0.5, width,
                                        changeIsFilled, true, 3),
                                  ],
                                ),
                                MCQ(
                                    7,
                                    mcqQuestions1Lesson4,
                                    'There are many types of prayer. Which of these did you do last week?',
                                    "",
                                    "",
                                    List<bool>.from(answers![3]),
                                    changeIsFilled,
                                    saveMcqAnswers1,
                                    true,
                                    1,
                                    0.0175),
                                MCQ(
                                    6,
                                    mcqQuestions2Lesson4,
                                    'There are many ways to pray. Which of these did you do last week?',
                                    "",
                                    "",
                                    List<bool>.from(answers![4]),
                                    changeIsFilled,
                                    saveMcqAnswers2,
                                    true,
                                    1,
                                    0.0175),
                                MCQ(
                                    4,
                                    mcqQuestions3Lesson4,
                                    'Do you pray in times of Joy? Sadness? Anxiety? Pain? Select all that apply',
                                    "",
                                    "",
                                    List<bool>.from(answers![5]),
                                    changeIsFilled,
                                    saveMcqAnswers3,
                                    true,
                                    1,
                                    0.0175),
                                FreeResponse(
                                  answers![6],
                                  "",
                                  'When you pray, what happens to your mental health?',
                                  '',
                                  "",
                                  "",
                                  "",
                                  "",
                                  changeIsFilled,
                                  saveFreeResponseAnswer2,
                                ),
                                YesOrNoType(
                                  answers![7],
                                  '',
                                  'Anxious and obsessed?',
                                  changeIsFilled,
                                  saveYesOrNo1,
                                ),
                                YesOrNoType(
                                  answers![8],
                                  '',
                                  'Hopeless or depressed',
                                  changeIsFilled,
                                  saveYesOrNo2,
                                ),
                                YesOrNoType(
                                  answers![9],
                                  '',
                                  'Ashamed or guilty?',
                                  changeIsFilled,
                                  saveYesOrNo3,
                                ),
                                YesOrNoType(
                                  answers![10],
                                  '',
                                  'Disconnected from reality?',
                                  changeIsFilled,
                                  saveYesOrNo4,
                                ),
                                YesOrNoType(
                                  answers![11],
                                  '',
                                  'Focused and alert?',
                                  changeIsFilled,
                                  saveYesOrNo5,
                                ),
                                YesOrNoType(
                                  answers![12],
                                  '',
                                  'Meaningful and purposeful?',
                                  changeIsFilled,
                                  saveYesOrNo6,
                                ),
                                YesOrNoType(
                                  answers![13],
                                  '',
                                  'Calm and peaceful?',
                                  changeIsFilled,
                                  saveYesOrNo7,
                                ),
                                YesOrNoType(
                                  answers![14],
                                  '',
                                  'Happy and hopeful?',
                                  changeIsFilled,
                                  saveYesOrNo8,
                                ),
                                FreeResponse(
                                  answers![15],
                                  '',
                                  'After going through all these exercises, are there any patterns you noticed about how praying effects your mental health? Any ideas on how to better use praying as a coping mechanism? Please describe below...',
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  changeIsFilled,
                                  saveFreeResponseAnswer3,
                                ),
                                SliderQuestion(
                                  "You did it! How do you feel after this lesson?",
                                  2,
                                  answers![16][0]!.toDouble(),
                                  answers![16][1]!.toDouble(),
                                  saveSliderAnswers,
                                  changeIsFilled,
                                  height,
                                  width,
                                  changeInitialSlider,
                                  isIntialChanged[1],
                                ),
                              ][index % 17];
                            },
                          ),
                        ),
                        Spacer(),
                        NavigateButtons(
                          pos != 16 ? 'NEXT' : 'FINISH',
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
