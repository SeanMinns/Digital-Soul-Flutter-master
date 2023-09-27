import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/FreeResponse.dart';
import 'package:digital_soul/Widgets/GridMCQWithOther.dart';
import 'package:digital_soul/Widgets/IconMCQ.dart';
import 'package:digital_soul/Widgets/MCQ.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digital_soul/Widgets/progress_bar.dart';
import '../Constants/Colors_App.dart';
import '../Widgets/CommonWidgets.dart';
import '../Widgets/navigate_buttons.dart';
import '../Widgets/Footer.dart';
import '../providers/profile.dart';

List<String> questions = [
  "1. What is the main reason why you have come to the hospital? (you may select more than one)",
  "2. How do you feel today? (you may select more than one icon that best describes how you feel)",
  "3. How is your spirituality relevant to your mental health?",
  "4. How does spirituality relate to your mental health? (select all that apply)",
];

class RegisterScreen3 extends StatefulWidget {
  @override
  _RegisterScreen3State createState() => _RegisterScreen3State();
}

class _RegisterScreen3State extends State<RegisterScreen3> {
  bool _isLoading = false;
  int pos = 0;
  List<dynamic>? answers;
  List<bool>? _isFilled;
  String other = '';
  OverlayEntry entry = loading();

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
    entry.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isFilled = [
      false,
      false,
      false,
      false,
    ];

    answers = [
      [],
      '',
      '',
      [],
    ];
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

  void saveIconMcqAnswers(String answer) {
    // setState(() {
    answers![1] = answer;
    // });
  }

  void saveMcqAnswers1(List<bool> mcq) {
    // setState(() {
    answers![0] = mcq;
    // var selectedIndex = mcq.indexWhere((element) => element);
    // selectedMcq = mcqQuestionsLesson1[selectedIndex];
    // });
  }

  void saveOther(String value) {
    other = value;
  }

  void saveMcqAnswers2(List<bool> mcq) {
    // setState(() {
    answers![3] = mcq;
    // var selectedIndex = mcq.indexWhere((element) => element);
    // selectedMcq = mcqQuestionsLesson1[selectedIndex];
    // });
  }

  void saveFreeResponseAnswer1(String value) {
    answers![2] = value;
  }

  void nextPage() async {
    if (pos != 3) {
      changePos(pos + 1);
      _controller.nextPage(duration: _kDuration, curve: _kCurve);
    } else {
      try {
        List<String> mcq1 = [];
        List<String> mcq2 = [];
        for (int i = 0; i < answers![0].length - 1; i++) {
          if (answers![0][i]) {
            mcq1.add(mcqQuestions1Register3[i]);
          }
        }
        if (answers![0][answers![0].length - 1]) {
          mcq1.add(other);
        }
        for (int i = 0; i < answers![3].length; i++) {
          if (answers![3][i]) {
            mcq2.add(mcqQuestions2Register3[i]);
          }
        }
        setState(() {
          _isLoading = true;
        });
        showOverlay(false, context);
        String answer1 = mcq1.join(', ');
        String answer2 = mcq2.join(', ');
        List<dynamic> answerData = [
          answer1,
          answers![1],
          answers![2],
          answer2,
        ];
        print(answerData);
        var profile = Provider.of<UserProfile>(context, listen: false).item;
        var keyWords = suicidalWords
            .where((word) => answers![2].toString().contains(word))
            .toList();
        await Provider.of<UserProfile>(context, listen: false)
            .addInitialQuestions(questions, answerData);
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
              .addSuicideWords(keyWords, 'register');
        }
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        await overlayPopup(
          'assets/RegistrationComplete.png',
          'You\'re Registered!',
          'You can now watch our introduction video and answer 6 questionnaires to help us customise your DigitalSoul.',
          'Let’s Get Started',
          context,
          0.95,
        );
        Navigator.of(context)
            .pushNamed(ScreenNavigationConstant.IntroductionVideoScreen);
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
    if (pos != 0) {
      changePos(pos - 1);
      _controller.previousPage(
        duration: _kDuration,
        curve: _kCurve,
      );
    } else {
      print('Cannot go to previous page');
    }
  }

  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 500);
  static const _kCurve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProfile>(context, listen: false).item;
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    int _curPage = 3;
    StepProgressView _getStepProgress() {
      return StepProgressView(
        _curPage,
        height,
        width * 0.7,
        width * 0.01,
        (height > 1000 || width > 400) ? height * 0.03 : height * 0.02,
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: backGround,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Opacity(
              opacity: _isLoading ? 0.3 : 1,
              child: IgnorePointer(
                ignoring: _isLoading,
                child: SizedBox(
                  height: height,
                  child: Column(
                    children: [
                      Container(
                        color: purpleBG,
                        child: Column(
                          children: [
                            Container(
                              height: (height > 1000 || width > 400)
                                  ? height * 0.1
                                  : height * 0.09,
                              child: _getStepProgress(),
                            ),
                            registerHeading(
                              'Hi ${profile!.firstName}',
                              // 'Hi Jane',
                              'Please answer the following',
                              height,
                              width,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: height * 0.55,
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: 4,
                          physics: new NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return [
                              GridMCQWithOther(
                                7,
                                mcqQuestions1Register3,
                                questions[0],
                                changeIsFilled,
                                List<bool>.from(answers![0]),
                                saveMcqAnswers1,
                                other,
                                saveOther,
                              ),
                              IconMCQ(
                                answers![1],
                                iconMcqQuestions,
                                mcqIcons,
                                questions[1],
                                changeIsFilled,
                                saveIconMcqAnswers,
                              ),
                              FreeResponse(
                                answers![2],
                                '',
                                questions[2],
                                "",
                                "",
                                "",
                                "",
                                "",
                                changeIsFilled,
                                saveFreeResponseAnswer1,
                              ),
                              MCQ(
                                  4,
                                  mcqQuestions2Register3,
                                  questions[3],
                                  "",
                                  "",
                                  List<bool>.from(answers![3]),
                                  changeIsFilled,
                                  saveMcqAnswers2,
                                  false,
                                  0,
                                  0.0175),
                            ][index % 4];
                          },
                        ),
                      ),
                      Spacer(),
                      pos == 0
                          ? NavigateButtons(
                              'PROCEED',
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
