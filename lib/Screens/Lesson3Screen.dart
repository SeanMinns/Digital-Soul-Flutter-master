import 'dart:convert';

import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/DropDownWithFreeResponse.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/FreeResponse.dart';
import 'package:digital_soul/Widgets/GradientProgressBar.dart';
import 'package:digital_soul/Widgets/MCQWithDropDown.dart';
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

class Lesson3Screen extends StatefulWidget {
  const Lesson3Screen({Key? key}) : super(key: key);

  @override
  _Lesson3ScreenState createState() => _Lesson3ScreenState();
}

class _Lesson3ScreenState extends State<Lesson3Screen> {
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 600);
  static const _kCurve = Curves.ease;
  int pos = 0;
  bool _isLoading = false;
  bool _isInit = true;
  List<bool>? _isFilled;
  List<dynamic>? answers;
  String? selectedDropDown;
  bool? showPopup;
  GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  Icon icon = Icon(Icons.more_horiz);
  OverlayEntry entry = loading();
  List<bool> isIntialChanged = [false, false];
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
    _overlayEntry = moreOverlay(buttonPosition, buttonSize, true, 2, () {
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
      ['', ''],
      '',
      ['', ''],
      [0, 0],
    ];

    selectedDropDown = '';
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
        print(json.decode(data['answers'][0]));
        for (int i = 0; i < data['answers'].length; i++) {
          _isFilled![i] = true;
          time[i] = data['timer'][i];
          if (i == 0 || i == 6) {
            answers![i] = json.decode(data['answers'][i]);
          } else if (i == 3 || i == 5) {
            final regExp = RegExp(r'(?:\[)?(\[[^\]]*?\](?:,?))(?:\])?');
            final result = regExp
                .allMatches(data['answers'][i])
                .map((m) => m.group(1))
                .map((String? item) => item!.replaceAll(RegExp(r'[\[\]]'), ''))
                .map((m) => [m])
                .toList();
            List<String> _list = result[0][0].split(', ');
            answers![i] = _list;
          } else {
            answers![i] = data['answers'][i];
          }
        }
        selectedDropDown = answers![3][1];
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
      print(profileId);
      var getData =
          await DatabaseHelper.instance.querySome(profileId!, 3, pos + 1);
      print(getData);
      if (getData.length == 0) {
        var insertData = await DatabaseHelper.instance.insert({
          DatabaseHelper.userId: '$profileId',
          DatabaseHelper.lessonNo: 3,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(insertData);
        Provider.of<Lessons>(context, listen: false).addQuestion(
          2,
          '${answers![pos]}',
          time[pos],
        );
      } else {
        var updateData = await DatabaseHelper.instance.update({
          DatabaseHelper.columnId: getData[0]['_id'],
          DatabaseHelper.userId: profileId,
          DatabaseHelper.lessonNo: 3,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(updateData);
        Provider.of<Lessons>(context, listen: false).updateQuestion(
          2,
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
        List<String> lesson3Questions = [
          "How would you rate your mood right now?",
          "Can you tell us why you picked this lesson?",
          "Please watch this lesson video. ",
          "Please select one Spiritual/ Religious struggle that you are currently experiencing",
          "How may your struggles with " +
              selectedDropDown! +
              " be relevant to your symptoms?",
          "[Please identify one individual you can approach to discuss these struggles within the next week, Could you talk a bit more about how you could contact the person and why you think talking with them could help?]",
          "You did it! How do you feel after this lesson?",
        ];
        List<dynamic> answerData = [
          "${emotionText[answers![0][0]]}, ${stressText[answers![0][1]]}",
          answers![1],
          answers![2],
          "${answers![3][0]}, ${answers![3][1]}",
          answers![4],
          "${answers![5][0]}, ${answers![5][1]}",
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
            .where((word) => answers![5][1].toString().contains(word))
            .toList();
        var finalKeyWords =
            [...keyWords1, ...keyWords2, ...keyWords3].toSet().toList();
        await Provider.of<Lessons>(context, listen: false)
            .addLesson("3", lesson3Questions, answerData, time);
        Provider.of<Lessons>(context, listen: false).addProgress(3);
        var profileId =
            Provider.of<UserProfile>(context, listen: false).item!.id;
        var deletedData =
            await DatabaseHelper.instance.deleteLesson(profileId!, 3);
        print(deletedData);
        Provider.of<Lessons>(context, listen: false).deleteLesson(2);
        if (finalKeyWords.length != 0) {
          var message = " UserId: ${profile!.id}, KeyWordsUsed: $finalKeyWords";
          await Provider.of<Lessons>(context, listen: false)
              .sendEmailToChaplain(
            profile.id!,
            profile.email!,
            message,
          );
          await Provider.of<Lessons>(context, listen: false)
              .addSuicideWords(finalKeyWords, 'lesson3');
        }
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        Navigator.of(context).popAndPushNamed(
          ScreenNavigationConstant.PopupLessonScreen,
          arguments: {
            'route': 'assets/Lesson3Popup2.png',
            'color': lesson3,
            'number': '3',
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
        if (error.toString() != 'Failed to add lesson 3') {
          Navigator.of(context).popAndPushNamed(
            ScreenNavigationConstant.PopupLessonScreen,
            arguments: {
              'route': 'assets/Lesson3Popup2.png',
              'color': lesson3,
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
          await DatabaseHelper.instance.querySome(profileId!, 3, pos + 1);
      print(getData);
      if (getData.length == 0) {
        var insertData = await DatabaseHelper.instance.insert({
          DatabaseHelper.userId: '$profileId',
          DatabaseHelper.lessonNo: 3,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(insertData);
        Provider.of<Lessons>(context, listen: false).addQuestion(
          2,
          '${answers![pos]}',
          time[pos],
        );
      } else {
        var updateData = await DatabaseHelper.instance.update({
          DatabaseHelper.columnId: getData[0]['_id'],
          DatabaseHelper.userId: profileId,
          DatabaseHelper.lessonNo: 3,
          DatabaseHelper.questionNo: pos + 1,
          DatabaseHelper.answer: '${answers![pos]}',
          DatabaseHelper.timer: time[pos],
        });
        print(updateData);
        Provider.of<Lessons>(context, listen: false).updateQuestion(
          2,
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

  void saveDropDownWithFreeAnswers(String answer1, String answer2) {
    // setState(() {
    answers![5][0] = answer1;
    answers![5][1] = answer2;
    // });
  }

  void saveMCQWithDropDown(String answer1, String answer2) {
    // setState(() {
    answers![3][0] = answer1;
    answers![3][1] = answer2;
    selectedDropDown = answer2;
    // });
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
                          color: lesson3,
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
                                  "Lesson 3",
                                  style: styles.getBlackHeading(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "SPIRITUAL/RELIGIOUS STRUGGLES",
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
                                  leftColor: lesson3ProgresLeft,
                                  rightColor: lesson3ProgresRight,
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
                                      2,
                                    ),
                                  ],
                                ),
                                MCQWithDropDown(
                                  mcqQuestionsLesson3,
                                  answers![3][0],
                                  'Please select one Spiritual/ Religious struggle that you are currently experiencing',
                                  answers![3][1],
                                  [
                                    mcqQuestionsWithDropdown1Lesson3,
                                    mcqQuestionsWithDropdown2Lesson3,
                                    mcqQuestionsWithDropdown3Lesson3
                                  ],
                                  changeIsFilled,
                                  saveMCQWithDropDown,
                                ),
                                FreeResponse(
                                  answers![4],
                                  '',
                                  'How may your struggles with ',
                                  selectedDropDown!
                                      .toLowerCase()
                                      .replaceAll('god', 'God'),
                                  ' be relevant to your symptoms?',
                                  "",
                                  "",
                                  "",
                                  changeIsFilled,
                                  saveFreeResponseAnswer2,
                                ),
                                DropDownWithFreeResponse(
                                  dropDownQuestionsLesson3,
                                  answers![5][0],
                                  'Please identify one individual you can approach to discuss these struggles within the next week',
                                  answers![5][1],
                                  'Could you talk a bit more about how you could contact the person and why you think talking with them could help?',
                                  changeIsFilled,
                                  saveDropDownWithFreeAnswers,
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
