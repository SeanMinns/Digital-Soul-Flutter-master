import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/GradientProgressBar.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PickLesson extends StatefulWidget {
  @override
  _PickLessonState createState() => _PickLessonState();
}

class _PickLessonState extends State<PickLesson> {
  GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  Icon icon = Icon(Icons.more_horiz);

  @override
  void initState() {
    _key = LabeledGlobalKey("button_icon");
    super.initState();
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
  Widget build(BuildContext context) {
    var lessons = Provider.of<Lessons>(context).lessons;
    var progressData = Provider.of<Lessons>(context, listen: false).progress;
    List map = [
      {
        'icon': "assets/brain.png",
        'name': "Spiritual/Religious Beliefs & Reframes",
        'total': 7,
        'progress': lessons[0].progress == 0 && progressData.contains(1)
            ? 7
            : lessons[0].progress,
        'color': lesson1
      },
      {
        'icon': "assets/meditation.png",
        'name': "Spiritual/Religious Coping in Treatment",
        'total': 7,
        'progress': lessons[1].progress == 0 && progressData.contains(2)
            ? 7
            : lessons[1].progress,
        'color': lesson2
      },
      {
        'icon': "assets/question_marks.png",
        'name': "Spiritual/Religious Struggles",
        'total': 7,
        'progress': lessons[2].progress == 0 && progressData.contains(3)
            ? 7
            : lessons[2].progress,
        'color': lesson3
      },
      {
        'icon': "assets/praying_hands.png",
        'name': "The Power of Prayer",
        'total': 17,
        'progress': lessons[3].progress == 0 && progressData.contains(4)
            ? 17
            : lessons[3].progress,
        'color': lesson4
      },
      {
        'icon': "assets/heart_hand.png",
        'name': "Forgiveness",
        'total': 7,
        'progress': lessons[4].progress == 0 && progressData.contains(5)
            ? 7
            : lessons[4].progress,
        'color': lesson5,
      },
    ];

    List page = [
      ScreenNavigationConstant.Lesson1Screen,
      ScreenNavigationConstant.Lesson2Screen,
      ScreenNavigationConstant.Lesson3Screen,
      ScreenNavigationConstant.Lesson4Screen,
      ScreenNavigationConstant.Lesson5Screen,
    ];
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  color: darkBlue,
                  height: height * 0.2,
                  padding: EdgeInsets.only(top: height * 0.01),
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
                          // iconSize: height*0.02,
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
                        //margin: EdgeInsets.only(top: height * 0.01),
                        child: Text(
                          "Your Lessons",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: height * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.005),
                        child: Text(
                          "Which lesson would you like to pick?",
                          style: GoogleFonts.nunito(
                            fontSize: height * 0.02,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.7,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: checkTablet(height, width)
                          ? width * 0.05
                          : width * 0.07,
                      vertical: height * 0.03,
                    ),
                    children: [
                      SizedBox(
                        height: height * 0.01,
                      ),
                      checkTablet(height, width)
                          ? GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: height * 0.005,
                                crossAxisSpacing: width * 0.01,
                                mainAxisExtent: height * 0.2,
                              ),
                              itemBuilder: (ctx, i) => Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isMenuOpen) closeMenu();
                                      });
                                      if (map[i]['progress'] ==
                                          map[i]['total']) {
                                        overlayPopup2(
                                          'assets/picklessonpopup.png',
                                          'We\'re Proud of You',
                                          'We are happy to see that you are ready to try this lesson again. Let\'s get started with it.',
                                          'LET\'S GO!',
                                          () {
                                            Navigator.of(context)
                                                .pushNamed(page[i], arguments: {
                                              "answers": lessons[i].answers,
                                              "timer": lessons[i].timer,
                                            });
                                          },
                                          context,
                                        );
                                      } else {
                                        if (lessons[i].answers!.isEmpty) {
                                          overlayPopup3(
                                            'assets/picklessonpopup.png',
                                            'Captions?',
                                            'Do you want to enable captions in the lesson video',
                                            'Yes',
                                            'No',
                                            () {
                                              Provider.of<Lessons>(context,
                                                      listen: false)
                                                  .changeCaptions(i, true);
                                              Navigator.of(context).pushNamed(
                                                  page[i],
                                                  arguments: {
                                                    "answers":
                                                        lessons[i].answers,
                                                    "timer": lessons[i].timer,
                                                  });
                                            },
                                            () {
                                              Provider.of<Lessons>(context,
                                                      listen: false)
                                                  .changeCaptions(i, false);
                                              Navigator.of(context).pushNamed(
                                                  page[i],
                                                  arguments: {
                                                    "answers":
                                                        lessons[i].answers,
                                                    "timer": lessons[i].timer,
                                                  });
                                            },
                                            context,
                                          );
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed(page[i], arguments: {
                                            "answers": lessons[i].answers,
                                            "timer": lessons[i].timer,
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: checkTablet(height, width)
                                          ? height * 0.18
                                          : height * 0.27,
                                      width: checkTablet(height, width)
                                          ? width * 0.5
                                          : double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        color: map[i]['color'],
                                        elevation: 0,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(height * 0.02),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                child:
                                                    /*SvgPicture.asset(
                                                map[i]['icon'].toString(),
                                                fit: BoxFit.fill,
                                                height: (height>920)?width*0.15:width*0.3,
                                                width: (height>920)?width*0.15:width*0.3,
                                              ),
                                            ),*/
                                                    Image.asset(
                                                  map[i]['icon'],
                                                  fit: BoxFit.fill,
                                                  height:
                                                      checkTablet(height, width)
                                                          ? width * 0.15
                                                          : width * 0.3,
                                                  width:
                                                      checkTablet(height, width)
                                                          ? width * 0.15
                                                          : width * 0.3,
                                                ),
                                              ),

                                              // CircleAvatar(
                                              //     radius: width * 0.15,
                                              //     backgroundColor: buttonColor,
                                              //     backgroundImage: AssetImage(
                                              //         map[i]['icon'])),
                                              SizedBox(
                                                width: width * 0.025,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: height * 0.01,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "LESSON " +
                                                              (i + 1)
                                                                  .toString(),
                                                          style: GoogleFonts
                                                              .nunito(
                                                            color: textDarkgrey,
                                                            fontSize:
                                                                height * 0.018,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: map[i][
                                                                          'progress'] ==
                                                                      map[i][
                                                                          'total']
                                                                  ? buttonColor
                                                                  : Colors
                                                                      .white),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: map[i][
                                                                        'progress'] ==
                                                                    map[i][
                                                                        'total']
                                                                ? Icon(
                                                                    Icons.check,
                                                                    size:
                                                                        height *
                                                                            0.02,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                : Container(
                                                                    width:
                                                                        height *
                                                                            0.02,
                                                                    height:
                                                                        height *
                                                                            0.02,
                                                                  ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.015,
                                                    ),
                                                    GradientProgressBar(
                                                      size: 7,
                                                      totalSteps: map[i]
                                                          ['total'],
                                                      curStep: map[i]
                                                          ['progress'],
                                                      leftColor: gradientPink,
                                                      rightColor: gradientBlue,
                                                      unselectedColor:
                                                          Colors.white,
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.01,
                                                    ),
                                                    Text(
                                                      map[i]['name'],
                                                      style: GoogleFonts.nunito(
                                                        fontSize: checkTablet(
                                                                height, width)
                                                            ? width * 0.02
                                                            : width * 0.045,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: textDarkgrey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.005),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                ],
                              ),
                              itemCount: 5,
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, i) => Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isMenuOpen) closeMenu();
                                      });
                                      if (map[i]['progress'] ==
                                          map[i]['total']) {
                                        overlayPopup2(
                                          'assets/picklessonpopup.png',
                                          'We\'re Proud of You',
                                          'We are happy to see that you are ready to try this lesson again. Let\'s get started with it.',
                                          'LET\'S GO!',
                                          () {
                                            Navigator.of(context)
                                                .pushNamed(page[i], arguments: {
                                              "answers": lessons[i].answers,
                                              "timer": lessons[i].timer,
                                            });
                                          },
                                          context,
                                        );
                                      } else {
                                        if (lessons[i].answers!.isEmpty) {
                                          overlayPopup3(
                                            'assets/picklessonpopup.png',
                                            'Captions?',
                                            'Do you want to enable captions in the lesson video',
                                            'Yes',
                                            'No',
                                            () {
                                              Provider.of<Lessons>(context,
                                                      listen: false)
                                                  .changeCaptions(i, true);
                                              Navigator.of(context).pushNamed(
                                                  page[i],
                                                  arguments: {
                                                    "answers":
                                                        lessons[i].answers,
                                                    "timer": lessons[i].timer,
                                                  });
                                            },
                                            () {
                                              Provider.of<Lessons>(context,
                                                      listen: false)
                                                  .changeCaptions(i, false);
                                              Navigator.of(context).pushNamed(
                                                  page[i],
                                                  arguments: {
                                                    "answers":
                                                        lessons[i].answers,
                                                    "timer": lessons[i].timer,
                                                  });
                                            },
                                            context,
                                          );
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed(page[i], arguments: {
                                            "answers": lessons[i].answers,
                                            "timer": lessons[i].timer,
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: checkTablet(height, width)
                                          ? height * 0.14
                                          : height * 0.27,
                                      width: checkTablet(height, width)
                                          ? width * 0.5
                                          : double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        color: map[i]['color'],
                                        elevation: 0,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              checkTablet(height, width)
                                                  ? height * 0.01
                                                  : height * 0.02),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                child:
                                                    /*SvgPicture.asset(
                                                  map[i]['icon'].toString(),
                                                  fit: BoxFit.fill,
                                                  height: (height > 920)
                                                      ? width * 0.15
                                                      : width * 0.3,
                                                  width: (height > 920)
                                                      ? width * 0.15
                                                      : width * 0.3,
                                                ),
                                              ),*/
                                                    Image.asset(
                                                  map[i]['icon'],
                                                  fit: BoxFit.fill,
                                                  height:
                                                      checkTablet(height, width)
                                                          ? width * 0.15
                                                          : width * 0.3,
                                                  width:
                                                      checkTablet(height, width)
                                                          ? width * 0.15
                                                          : width * 0.3,
                                                ),
                                              ),

                                              // CircleAvatar(
                                              //     radius: width * 0.15,
                                              //     backgroundColor: buttonColor,
                                              //     backgroundImage: AssetImage(
                                              //         map[i]['icon'])),
                                              SizedBox(
                                                width: width * 0.05,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: height * 0.01,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "LESSON " +
                                                              (i + 1)
                                                                  .toString(),
                                                          style: GoogleFonts
                                                              .nunito(
                                                            color: textDarkgrey,
                                                            fontSize: (height >
                                                                    920)
                                                                ? width * 0.02
                                                                : height *
                                                                    0.018,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: map[i][
                                                                          'progress'] ==
                                                                      map[i][
                                                                          'total']
                                                                  ? buttonColor
                                                                  : Colors
                                                                      .white),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: map[i][
                                                                        'progress'] ==
                                                                    map[i][
                                                                        'total']
                                                                ? Icon(
                                                                    Icons.check,
                                                                    size:
                                                                        height *
                                                                            0.02,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                : Container(
                                                                    width:
                                                                        height *
                                                                            0.02,
                                                                    height:
                                                                        height *
                                                                            0.02,
                                                                  ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.015,
                                                    ),
                                                    GradientProgressBar(
                                                      size: 7,
                                                      totalSteps: map[i]
                                                          ['total'],
                                                      curStep: map[i]
                                                          ['progress'],
                                                      leftColor: gradientPink,
                                                      rightColor: gradientBlue,
                                                      unselectedColor:
                                                          Colors.white,
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.01,
                                                    ),
                                                    Text(
                                                      map[i]['name'],
                                                      style: GoogleFonts.nunito(
                                                        fontSize: checkTablet(
                                                                height, width)
                                                            ? width * 0.02
                                                            : width * 0.045,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: textDarkgrey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.005),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: checkTablet(height, width)
                                          ? height * 0.005
                                          : height * 0.01),
                                ],
                              ),
                              itemCount: 5,
                            ),
                    ],
                  ),
                ),
                Spacer(),
                Footer(height, width),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
