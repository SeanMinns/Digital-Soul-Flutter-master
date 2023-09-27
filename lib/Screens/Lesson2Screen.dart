import 'dart:convert';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/DropDown.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/FreeResponse.dart';
import 'package:digital_soul/Widgets/GradientProgressBar.dart';
import 'package:digital_soul/Widgets/SliderQuestion.dart';
import 'package:digital_soul/Widgets/VideoWidget.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/database_helper.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:digital_soul/providers/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Constants/Text_Styles.dart';

class Lesson2Screen extends StatefulWidget {
  const Lesson2Screen({Key? key}) : super(key: key);

  @override
  _Lesson2ScreenState createState() => _Lesson2ScreenState();
}

class _Lesson2ScreenState extends State<Lesson2Screen> {
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 600);
  static const _kCurve = Curves.ease;
  int pos = 0;
  bool _isLoading = false;
  bool _isInit = true;
  List<bool>? _isFilled;
  List<dynamic>? answers;
  bool? showPopup;
  GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  Icon icon = Icon(Icons.more_horiz);
  OverlayEntry entry = loading();

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
    _overlayEntry = moreOverlay(buttonPosition, buttonSize, true, 1, () {
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
    ];
    time = [
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
      '',
      '',
      '',
      [0, 0],
    ];

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
          if (i == 0 || i == 6) {
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
  }

  void changeIsFilled(bool value) {
    setState(() {
      _isFilled![pos] = value;
    });
  }

  void nextPage() async {
    // var allData = await DatabaseHelper.instance.deleteAll();
    if (pos != 6) {
      handleStartStop(0, pos);
      var profileId = Provider.of<UserProfile>(context, listen: false).item!.id;
      print("ID is" + profileId.toString());
      var getData =
          await DatabaseHelper.instance.querySome(profileId!, 2, pos + 1);
      print(getData);
      if (getData.length == 0) {
        var insertData = await DatabaseHelper.instance.insert({
          DatabaseHelper.userId: '$profileId',
          DatabaseHelper.lessonNo: 2,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(insertData);
        Provider.of<Lessons>(context, listen: false).addQuestion(
          1,
          '${answers![pos]}',
          time[pos],
        );
      } else {
        var updateData = await DatabaseHelper.instance.update({
          DatabaseHelper.columnId: getData[0]['_id'],
          DatabaseHelper.userId: profileId,
          DatabaseHelper.lessonNo: 2,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(updateData);
        Provider.of<Lessons>(context, listen: false).updateQuestion(
          1,
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
        List<String> lesson2Questions = [
          "How would you rate your mood right now?",
          "Can you tell us why you picked this lesson?",
          "Please watch this lesson video. ",
          "Please select one activity that may be helpful to focus on your treatment",
          "Could you please describe how believing that " +
              mapQuestionLesson2[answers![3]]![0] +
              " could be relevant to the symptoms you are experiencing?",
          "Is there anyway you could use " +
              mapQuestionLesson2[answers![3]]![0] +
              ", as a coping strategy each day going forward? Please describe below.",
          "You did it! How do you feel after this lesson?",
        ];
        List<dynamic> answerData = [
          "${emotionText[answers![0][0]]}, ${stressText[answers![0][1]]}",
          answers![1],
          answers![2],
          answers![3],
          answers![4],
          answers![5],
          "${emotionText[answers![6][0]]}, ${stressText[answers![6][1]]}",
        ];
        print(answerData);
        var profile = Provider.of<UserProfile>(context, listen: false).item;
        var keyWords1 = suicidalWords
            .where((word) => answers![1].toString().contains(word))
            .toList();
        var keyWords2 = suicidalWords
            .where((word) => answers![4].toString().contains(word))
            .toList();
        var keyWords3 = suicidalWords
            .where((word) => answers![5].toString().contains(word))
            .toList();
        var finalKeyWords =
            [...keyWords1, ...keyWords2, ...keyWords3].toSet().toList();
        await Provider.of<Lessons>(context, listen: false)
            .addLesson("2", lesson2Questions, answerData, time);
        Provider.of<Lessons>(context, listen: false).addProgress(2);
        var profileId =
            Provider.of<UserProfile>(context, listen: false).item!.id;
        var deletedData =
            await DatabaseHelper.instance.deleteLesson(profileId!, 2);
        print(deletedData);
        Provider.of<Lessons>(context, listen: false).deleteLesson(1);
        if (finalKeyWords.length != 0) {
          var message = " UserId: ${profile!.id}, KeyWordsUsed: $finalKeyWords";
          await Provider.of<Lessons>(context, listen: false)
              .sendEmailToChaplain(
            profile.id!,
            profile.email!,
            message,
          );
          await Provider.of<Lessons>(context, listen: false)
              .addSuicideWords(finalKeyWords, 'lesson2');
        }
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        Navigator.of(context).popAndPushNamed(
          ScreenNavigationConstant.PopupLessonScreen,
          arguments: {
            'route': 'assets/Lesson2Popup2.png',
            'color': lesson2,
            'number': '2',
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
        if (error.toString() != 'Failed to add lesson 2') {
          Navigator.of(context).popAndPushNamed(
            ScreenNavigationConstant.PopupLessonScreen,
            arguments: {
              'route': 'assets/Lesson2Popup2.png',
              'color': lesson2,
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
          await DatabaseHelper.instance.querySome(profileId!, 2, pos + 1);
      print(getData);
      if (getData.length == 0) {
        var insertData = await DatabaseHelper.instance.insert({
          DatabaseHelper.userId: '$profileId',
          DatabaseHelper.lessonNo: 2,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(insertData);
        Provider.of<Lessons>(context, listen: false).addQuestion(
          1,
          '${answers![pos]}',
          time[pos],
        );
      } else {
        var updateData = await DatabaseHelper.instance.update({
          DatabaseHelper.columnId: getData[0]['_id'],
          DatabaseHelper.userId: profileId,
          DatabaseHelper.lessonNo: 2,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(updateData);
        Provider.of<Lessons>(context, listen: false).updateQuestion(
          1,
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
        answers![6][0] = emotions;
        // });
      }
      if (stressText[stress].length > 0) {
        // setState(() {
        answers![6][1] = stress;
        // });
      }
    }
  }

  void saveFreeResponseAnswer1(String value) {
    answers![1] = value;
  }

  void saveFreeResponseAnswer2(String value) {
    answers![4] = value;
  }

  void saveFreeResponseAnswer3(String value) {
    answers![5] = value;
  }

  void saveDropDownAnswers(String answer) {
    setState(() {
      answers![3] = answer;
    });
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
                          color: lesson2,
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
                                  "Lesson 2",
                                  style: styles.getBlackHeading(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "SPIRITUAL/RELIGIOUS COPING IN TREATMENT",
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
                                  totalSteps: 7,
                                  curStep: pos + 1,
                                  leftColor: lesson2ProgresLeft,
                                  rightColor: lesson2ProgresRight,
                                  unselectedColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: backGround,
                          height: height * 0.6,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: 7,
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
                                    VideoWidget(
                                      height * 0.5,
                                      width,
                                      changeIsFilled,
                                      true,
                                      1,
                                    ),
                                  ],
                                ),
                                DropDown(
                                  answers![3],
                                  dropdownQuestionsLesson2,
                                  '',
                                  'Please select a coping strategy that may be helpful to focus on in your treatment',
                                  changeIsFilled,
                                  saveDropDownAnswers,
                                  false,
                                ),
                                FreeResponse(
                                  answers![4],
                                  '',
                                  'Please describe how ',
                                  answers![3] == ''
                                      ? ""
                                      : mapQuestionLesson2[answers![3]]![0],
                                  ' could be relevant to the symptoms you are experiencing.',
                                  "",
                                  "",
                                  "",
                                  changeIsFilled,
                                  saveFreeResponseAnswer2,
                                ),
                                FreeResponse(
                                  answers![5],
                                  '',
                                  'Is there anyway you could use ',
                                  answers![3] == ''
                                      ? ""
                                      : mapQuestionLesson2[answers![3]]![0],
                                  ', as a coping strategy each day going forward? Please describe below.',
                                  "",
                                  "",
                                  "",
                                  changeIsFilled,
                                  saveFreeResponseAnswer3,
                                ),
                                SliderQuestion(
                                  "You did it! How do you feel after this lesson?",
                                  2,
                                  answers![6][0]!.toDouble(),
                                  answers![6][1]!.toDouble(),
                                  saveSliderAnswers,
                                  changeIsFilled,
                                  height,
                                  width,
                                  changeInitialSlider,
                                  isIntialChanged[1],
                                ),
                              ][index % 7];
                            },
                          ),
                        ),
                        Spacer(),
                        NavigateButtons(
                          pos != 6 ? 'NEXT' : 'FINISH',
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
