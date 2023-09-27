import 'package:flutter/cupertino.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDown extends StatefulWidget {
  final List<String> answers;
  final String answer;
  final String questions;
  final String mainQuestion;
  final Function changeFilled;
  final Function saveMcqAnswers;
  final bool isFaded;

  DropDown(
    this.answer,
    this.answers,
    this.mainQuestion,
    this.questions,
    this.changeFilled,
    this.saveMcqAnswers,
    this.isFaded,
  );

  @override
  _DropDown createState() => _DropDown(
        answer,
        answers,
        mainQuestion,
        questions,
        changeFilled,
        saveMcqAnswers,
        isFaded,
      );
}

class _DropDown extends State<DropDown> with SingleTickerProviderStateMixin {
  String answer;
  List<String> answers;
  String questions;
  String mainQuestion;
  bool isFaded;
  Function changeFilled;
  Color selected = blueSelected;
  Color unselected = Colors.transparent;
  List<String> userAnswers = [];
  Function saveMcqAnswers;
  String? dropdownValue;
  GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  BorderRadius? _borderRadius;
  Icon icon = Icon(Icons.arrow_drop_down);
  late String title;

  _DropDown(
    this.answer,
    this.answers,
    this.mainQuestion,
    this.questions,
    this.changeFilled,
    this.saveMcqAnswers,
    this.isFaded,
  );

  @override
  void initState() {
    title = (answer != '') ? answer : 'Please pick one';
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 250),
    // );
    _borderRadius = BorderRadius.circular(4);
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
    icon = Icon(Icons.arrow_drop_down);
    //  _animationController.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    //   _animationController.forward();
    icon = Icon(Icons.arrow_drop_up);
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: mainQuestion.length > 0 ? height * 0.02 : height * 0.015,
        horizontal: width * 0.06,
      ),
      child: Column(
        children: [
          mainQuestion.length > 0
              ? Container(
                  margin: EdgeInsets.only(
                    top: height * 0.01,
                    bottom: height * 0.02,
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(
                    mainQuestion,
                    style: styles.getBlueQuestionTextStyle(),
                  ),
                )
              : Container(),
          Container(
            child: Text(
              questions,
              style: styles.getQuestionTextStyle(),
            ),
          ),
          SizedBox(height: height * 0.03),
          InkWell(
            onTap: () {
              setState(() {
                if (isMenuOpen) {
                  closeMenu();
                } else {
                  openMenu();
                }
              });
            },
            child: Container(
              key: _key,
              decoration: BoxDecoration(
                color: greyBG,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(height * 0.003),
                    margin: EdgeInsets.only(left: width * 0.03),
                    child: Text(
                      title,
                      style: styles.getNormalTextStyle(),
                    ),
                  ),
                  IconButton(
                    icon: icon,
                    color: greyAnswers,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        Style styles = new Style(height, width);
        return Positioned(
          top: buttonPosition!.dy + buttonSize!.height,
          left: buttonPosition!.dx,
          width: buttonSize!.width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: height * 0.36,
              decoration: BoxDecoration(
                color: greyBG,
                borderRadius: _borderRadius,
              ),
              child: (isFaded)
                  ? ShaderMask(
                      shaderCallback: (Rect rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.purple,
                            Colors.purple,
                            Colors.transparent,
                          ],
                          stops: [
                            0.0,
                            0.2,
                            0.8,
                            1.0
                          ], // 10% purple, 80% transparent, 10% purple
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.dstIn,
                      child: ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        itemCount: answers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              title = answers[index];
                              changeFilled(true);
                              saveMcqAnswers(answers[index]);
                              closeMenu();
                            },
                            child: Container(
                              color: title == answers[index]
                                  ? selected
                                  : unselected,
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 1.0,
                                    width: width,
                                    color: Colors.black26,
                                  ),
                                  Container(
                                    height: height * 0.05,
                                    padding:
                                        EdgeInsets.only(left: width * 0.03),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      answers[index],
                                      style: title == answers[index]
                                          ? styles.getanswersWhiteTextStyle()
                                          : GoogleFonts.nunito(
                                              fontSize: height * 0.02,
                                              color: blueSelected,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: answers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            title = answers[index];
                            changeFilled(true);
                            saveMcqAnswers(answers[index]);
                            closeMenu();
                          },
                          child: Container(
                            color:
                                title == answers[index] ? selected : unselected,
                            width: width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 1.0,
                                  width: width,
                                  color: Colors.black26,
                                ),
                                Container(
                                  height: height * 0.05,
                                  padding: EdgeInsets.only(left: width * 0.03),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    answers[index],
                                    style: title == answers[index]
                                        ? styles.getanswersWhiteTextStyle()
                                        : GoogleFonts.nunito(
                                            fontSize: height * 0.02,
                                            color: blueSelected,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
