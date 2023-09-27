import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:digital_soul/Widgets/AddPrayer.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/MCQ.dart';
import 'package:digital_soul/Widgets/SliderQuestion.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Widgets/CommonWidgets.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_diary.dart';
import '../providers/profile.dart';

class NewDiaryEntry extends StatefulWidget {
  const NewDiaryEntry({Key? key}) : super(key: key);

  @override
  _NewDiaryEntryState createState() => _NewDiaryEntryState();
}

class _NewDiaryEntryState extends State<NewDiaryEntry> {
  bool _isLoading = false;
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 500);
  static const _kCurve = Curves.ease;
  int? beforeEmotions;
  int? afterEmotions;
  int? beforeStress;
  int? afterStress;
  List<bool>? mcqs;
  String? prayerEntry;
  int pos = 0;
  List<bool>? _isFilled;
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
    _overlayEntry = moreOverlay(buttonPosition, buttonSize, false, -1, () {
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
    beforeEmotions = 0;
    afterEmotions = 0;
    beforeStress = 0;
    afterStress = 0;
    mcqs = [];
    prayerEntry = '';
    _isFilled = [
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
    if (pos != 3) {
      handleStartStop(0, pos);
      changePos(pos + 1);
      _controller.nextPage(duration: _kDuration, curve: _kCurve);
    } else {
      handleStartStop(1, pos);
      List<String> prayerType = [];
      var i;
      for (i = 0; i < mcqs!.length; i++) {
        if (mcqs![i]) {
          prayerType.add(mcqWordQuestionsDiary[i]);
        }
      }
      try {
        setState(() {
          _isLoading = true;
        });
        showOverlay(false, context);
        var profile = Provider.of<UserProfile>(context, listen: false).item;
        var keyWords = suicidalWords
            .where((word) => prayerEntry.toString().contains(word))
            .toList();
        await Provider.of<Diary>(context, listen: false).addEntry(
          beforeEmotions! + 1,
          afterEmotions! + 1,
          beforeStress! + 1,
          afterStress! + 1,
          prayerType,
          prayerEntry!,
          time[2].toString(),
        );
        if (keyWords.length != 0) {
          var message =
              "Email: ${profile!.email}, UserId: ${profile.id}, KeyWordsUsed: $keyWords";
          await Provider.of<Lessons>(context, listen: false)
              .sendEmailToChaplain(
            profile.id!,
            profile.email!,
            message,
          );
          await Provider.of<Lessons>(context, listen: false)
              .addSuicideWords(keyWords, 'prayer-diary');
        }
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        var user = Provider.of<UserProfile>(context, listen: false).item;
        setState(() {
          if (isMenuOpen) closeMenu();
        });
        await overlayPopup(
          'assets/DiaryEndPopup.png',
          'Well Done, ${user!.firstName}',
          'You have completed your diary entry. Let\'s go and see what more you can try out today.',
          'HOMESCREEN',
          context,
          0.95,
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(ScreenNavigationConstant.homeScreen);
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
        beforeEmotions = emotions;
        // });
      }
      if (stressText[stress].length > 0) {
        // setState(() {
        beforeStress = stress;
        // });
      }
    } else {
      if (emotionText[emotions].length > 0) {
        // setState(() {
        afterEmotions = emotions;
        // });
      }
      if (stressText[stress].length > 0) {
        // setState(() {
        afterStress = stress;
        // });
      }
    }
  }

  void saveMcqAnswers(List<bool> mcq) {
    // setState(() {
    mcqs = mcq;
    // });
  }

  void savePrayerAnswer(String prayer) {
    // setState(() {
    prayerEntry = prayer;
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
              child: SizedBox(
                height: height,
                child: Container(
                  color: backGround,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: darkBlue,
                        height: height * 0.15,
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
                                "Your New Diary Entry",
                                style: styles.getWhiteHeading(),
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
                          itemCount: 4,
                          physics: new NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return [
                              SliderQuestion(
                                "How do you feel before praying? You can use the slider",
                                1,
                                beforeEmotions!.toDouble(),
                                beforeStress!.toDouble(),
                                saveSliderAnswers,
                                changeIsFilled,
                                height,
                                width,
                                changeInitialSlider,
                                isIntialChanged[0],
                              ),
                              MCQ(
                                2,
                                mcqQuestionsDiary,
                                "What type of prayer would you like to make today? You may select up to two.",
                                "",
                                "",
                                mcqs!,
                                changeIsFilled,
                                saveMcqAnswers,
                                true,
                                1,
                                0.0175,
                              ),
                              AddPrayer(
                                mcqs!,
                                prayerEntry!,
                                changeIsFilled,
                                savePrayerAnswer,
                              ),
                              SliderQuestion(
                                "How do you feel after praying? You can use the slider",
                                2,
                                afterEmotions!.toDouble(),
                                afterStress!.toDouble(),
                                saveSliderAnswers,
                                changeIsFilled,
                                height,
                                width,
                                changeInitialSlider,
                                isIntialChanged[1],
                              ),
                            ][index % 4];
                          },
                        ),
                      ),
                      Spacer(),
                      NavigateButtons(
                        'PROCEED',
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
    );
  }
}
