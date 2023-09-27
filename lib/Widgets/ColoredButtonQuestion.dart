import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColoredButtonQuestion extends StatefulWidget {
  final Function saveAnswers;
  final String question;
  final List answers;
  final List colors;
  final Function changeFilled;
  final List<bool> selected;

  ColoredButtonQuestion(this.question, this.colors, this.answers,
      this.changeFilled, this.saveAnswers, this.selected);

  @override
  _ColoredButtonQuestion createState() => _ColoredButtonQuestion(
      question, colors, answers, changeFilled, saveAnswers, selected);
}

class _ColoredButtonQuestion extends State<ColoredButtonQuestion> {
  final Function saveAnswers;
  final String question;
  final List answers;
  final List colors;
  final Function changeFilled;
  final List<bool> selected;

  _ColoredButtonQuestion(this.question, this.colors, this.answers,
      this.changeFilled, this.saveAnswers, this.selected);

  int pos = 0;
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();

    if (selected.length == 0) {
      for (int i = 0; i < answers.length; i++) {
        selected.add(false);
      }
    } else {
      for (int i = 0; i < answers.length; i++) {
        if (selected[i] == true) {
          pos = i;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    return Scaffold(
      backgroundColor: backGround,
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.06,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.03),
              child: Text(
                question,
                style: styles.getQuestionTextStyle(),
              ),
            ),
            SizedBox(height: height * 0.1),
            Container(
              margin: EdgeInsets.only(top: height * 0.012),
              child: Text(
                answers[pos],
                style: styles.getBoldTextStyle(),
              ),
            ),
            SizedBox(height: height * 0.02),
            Container(
              margin: EdgeInsets.only(
                left: width * 0.02,
              ),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < selected.length;
                            buttonIndex++) {
                          if (buttonIndex == 0) {
                            selected[buttonIndex] = true;
                            pos = 0;
                          } else {
                            selected[buttonIndex] = false;
                          }
                        }
                      });
                      changeFilled(true);
                      saveAnswers(selected);
                    },
                    child: Container(
                      height: height * 0.12,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: colors[0],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6)),
                            ),
                            child: SizedBox(
                              height: height * 0.05,
                              width: width * 0.2,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.02),
                            child: selected[0]
                                ? Image.asset(
                                    "assets/Triangle.png",
                                    height: 20,
                                  )
                                : SizedBox(
                                    height: height * 0.027,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < selected.length;
                            buttonIndex++) {
                          if (buttonIndex == 1) {
                            selected[buttonIndex] = true;
                            pos = 1;
                          } else {
                            selected[buttonIndex] = false;
                          }
                        }
                      });
                      changeFilled(true);
                      saveAnswers(selected);
                    },
                    child: Container(
                      height: height * 0.12,
                      child: Column(
                        children: [
                          Container(
                            color: colors[1],
                            child: SizedBox(
                              height: height * 0.05,
                              width: width * 0.2,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.02),
                            child: selected[1]
                                ? Image.asset(
                                    "assets/Triangle.png",
                                    height: 20,
                                  )
                                : SizedBox(
                                    height: height * 0.027,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < selected.length;
                            buttonIndex++) {
                          if (buttonIndex == 2) {
                            selected[buttonIndex] = true;
                            pos = 2;
                          } else {
                            selected[buttonIndex] = false;
                          }
                        }
                      });
                      changeFilled(true);
                      saveAnswers(selected);
                    },
                    child: Container(
                      height: height * 0.12,
                      child: Column(
                        children: [
                          Container(
                            color: colors[2],
                            child: SizedBox(
                              height: height * 0.05,
                              width: width * 0.2,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.02),
                            child: selected[2]
                                ? Image.asset(
                                    "assets/Triangle.png",
                                    height: 20,
                                  )
                                : SizedBox(
                                    height: height * 0.027,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < selected.length;
                            buttonIndex++) {
                          if (buttonIndex == 3) {
                            selected[buttonIndex] = true;
                            pos = 3;
                          } else {
                            selected[buttonIndex] = false;
                          }
                        }
                      });
                      changeFilled(true);
                      saveAnswers(selected);
                    },
                    child: Container(
                      height: height * 0.12,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: colors[3],
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6)),
                            ),
                            child: SizedBox(
                              height: height * 0.05,
                              width: width * 0.2,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.02),
                            child: selected[3]
                                ? Image.asset(
                                    "assets/Triangle.png",
                                    height: 20,
                                  )
                                : SizedBox(
                                    height: height * 0.027,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
