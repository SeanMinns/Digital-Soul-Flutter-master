import 'package:flutter/cupertino.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:google_fonts/google_fonts.dart';

class MCQ extends StatefulWidget {
  final int limit;
  final List<String> answers;
  final String questions;
  final String boldQuestion;
  final String normalQuestion1;
  final List<bool> mcqs;
  final Function changeFilled;
  final Function saveMcqAnswers;
  final bool setHeight;
  final int tileWidth;
  final double textSize;
  MCQ(
      this.limit,
      this.answers,
      this.questions,
      this.boldQuestion,
      this.normalQuestion1,
      this.mcqs,
      this.changeFilled,
      this.saveMcqAnswers,
      this.setHeight,
      this.tileWidth,
      this.textSize);

  @override
  _MCQ createState() => _MCQ(
      limit,
      answers,
      questions,
      boldQuestion,
      normalQuestion1,
      mcqs,
      changeFilled,
      saveMcqAnswers,
      setHeight,
      tileWidth,
      textSize);
}

class _MCQ extends State<MCQ> {
  int limit;
  List<String> answers;
  String questions;
  String boldQuestion;
  String normalQuestion1;
  Function changeFilled;
  List<bool> mcqs;
  Color selected = blueSelected;
  Color unselected = greyBG;
  List<String> userAnswers = [];
  Function saveMcqAnswers;
  bool setHeight;
  int tileWidth;
  double textSize;
  _MCQ(
      this.limit,
      this.answers,
      this.questions,
      this.boldQuestion,
      this.normalQuestion1,
      this.mcqs,
      this.changeFilled,
      this.saveMcqAnswers,
      this.setHeight,
      this.tileWidth,
      this.textSize);

  @override
  void initState() {
    super.initState();
    if (mcqs.length == 0) {
      for (int i = 0; i < answers.length; i++) {
        mcqs.add(false);
      }
    } else {
      for (int i = 0; i < answers.length; i++) {
        if (mcqs[i] == true) {
          userAnswers.add(answers[i]);
        }
      }
    }
  }

  bool checkTrue() {
    return mcqs.contains(true);
  }

  bool checkLimit() {
    int flag = 0;
    int count = 0;
    for (int i = 0; i < mcqs.length; i++) {
      if (mcqs[i]) {
        count++;
        if (count >= limit) {
          flag = 1;
          break;
        }
      }
    }
    if (flag == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    return Container(
      margin: EdgeInsets.symmetric(
        //vertical: height * 0.05,
        horizontal: width * 0.06,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.012),
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: questions,
                style: styles.getQuestionTextStyle(),
                children: <TextSpan>[
                  TextSpan(
                    text: boldQuestion,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: normalQuestion1,
                    style: styles.getQuestionTextStyle(),
                  ),
                ],
              ),
            ),

            /*Text(
              questions,
              style: styles.getQuestionTextStyle(),
            ),*/
          ),
          SizedBox(height: height * 0.02),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: mcqs[index] ? selected : unselected,
                  ),
                  // height: height * 0.06,
                  child: setHeight
                      ? SizedBox(
                          height:
                              tileWidth == 0 ? height * 0.1 : height * 0.056,
                          child: ListTile(
                            dense: true,
                            tileColor: mcqs[index] ? selected : unselected,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onTap: () {
                              if (mcqs[index]) {
                                setState(() {
                                  mcqs[index] = false;
                                  userAnswers.remove(answers[index]);
                                });
                                changeFilled(checkTrue());
                                saveMcqAnswers(mcqs);
                              } else {
                                if (checkLimit()) {
                                  if (userAnswers.contains('None of these')) {
                                    if (answers[index] != 'None of these') {
                                      setState(() {
                                        userAnswers.remove('None of these');
                                        mcqs[mcqs.length - 1] = false;
                                        mcqs[index] = true;
                                        userAnswers.add(answers[index]);
                                      });
                                    }
                                  } else {
                                    print('int this else');
                                    setState(() {
                                      if (answers[index] == 'None of these') {
                                        for (int i = 0; i < mcqs.length; i++) {
                                          mcqs[i] = false;
                                        }
                                        userAnswers.clear();
                                      }
                                      mcqs[index] = true;
                                      userAnswers.add(answers[index]);
                                    });
                                    changeFilled(true);
                                    saveMcqAnswers(mcqs);
                                  }
                                } else {
                                  if (userAnswers.length > 0) {
                                    if (userAnswers.contains('None of these')) {
                                      if (answers[index] != 'None of these') {
                                        setState(() {
                                          userAnswers.remove('None of these');
                                          mcqs[mcqs.length - 1] = false;
                                          mcqs[index] = true;
                                          userAnswers.add(answers[index]);
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        if (answers[index] == 'None of these') {
                                          for (int i = 0;
                                              i < mcqs.length;
                                              i++) {
                                            mcqs[i] = false;
                                          }
                                          userAnswers.clear();
                                        } else {
                                          mcqs[answers.indexOf(userAnswers[
                                              userAnswers.length - 1])] = false;
                                          userAnswers
                                              .removeAt(userAnswers.length - 1);
                                        }
                                        mcqs[index] = true;
                                        userAnswers.add(answers[index]);
                                      });
                                      saveMcqAnswers(mcqs);
                                      changeFilled(checkTrue());
                                    }
                                  }
                                }
                              }
                            },
                            title: Text(
                              answers[index],
                              style: mcqs[index]
                                  ? GoogleFonts.nunito(
                                      fontSize: (height > 920)
                                          ? height * textSize
                                          : height * 0.02,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : GoogleFonts.nunito(
                                      fontSize: (height > 920)
                                          ? height * textSize
                                          : height * 0.02,
                                      color: greyAnswers,
                                    ),
                            ),
                          ),
                        )
                      : SizedBox(
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.only(
                                top: height * 0.01,
                                bottom: height * 0.01,
                                left: height * 0.01),
                            tileColor: mcqs[index] ? selected : unselected,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onTap: () {
                              if (mcqs[index]) {
                                setState(() {
                                  mcqs[index] = false;
                                  userAnswers.remove(answers[index]);
                                });
                                changeFilled(checkTrue());
                                saveMcqAnswers(mcqs);
                              } else {
                                if (checkLimit()) {
                                  if (userAnswers.contains('None of these')) {
                                    if (answers[index] != 'None of these') {
                                      setState(() {
                                        userAnswers.remove('None of these');
                                        mcqs[mcqs.length - 1] = false;
                                        mcqs[index] = true;
                                        userAnswers.add(answers[index]);
                                      });
                                    }
                                  } else {
                                    print('int this else');
                                    setState(() {
                                      if (answers[index] == 'None of these') {
                                        for (int i = 0; i < mcqs.length; i++) {
                                          mcqs[i] = false;
                                        }
                                        userAnswers.clear();
                                      }
                                      mcqs[index] = true;
                                      userAnswers.add(answers[index]);
                                    });
                                    changeFilled(true);
                                    saveMcqAnswers(mcqs);
                                  }
                                } else {
                                  if (userAnswers.length > 0) {
                                    if (userAnswers.contains('None of these')) {
                                      if (answers[index] != 'None of these') {
                                        setState(() {
                                          userAnswers.remove('None of these');
                                          mcqs[mcqs.length - 1] = false;
                                          mcqs[index] = true;
                                          userAnswers.add(answers[index]);
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        if (answers[index] == 'None of these') {
                                          for (int i = 0;
                                              i < mcqs.length;
                                              i++) {
                                            mcqs[i] = false;
                                          }
                                          userAnswers.clear();
                                        } else {
                                          mcqs[answers.indexOf(userAnswers[
                                              userAnswers.length - 1])] = false;
                                          userAnswers
                                              .removeAt(userAnswers.length - 1);
                                        }
                                        mcqs[index] = true;
                                        userAnswers.add(answers[index]);
                                      });
                                      saveMcqAnswers(mcqs);
                                      changeFilled(checkTrue());
                                    }
                                  }
                                }
                              }
                            },
                            title: Text(
                              answers[index],
                              style: mcqs[index]
                                  ? GoogleFonts.nunito(
                                      fontSize: (height > 920)
                                          ? height * textSize
                                          : height * 0.02,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : GoogleFonts.nunito(
                                      fontSize: (height > 920)
                                          ? height * textSize
                                          : height * 0.02,
                                      color: greyAnswers,
                                    ),
                            ),
                          ),
                        ));
            },
            separatorBuilder: (context, item) {
              return setHeight
                  ? SizedBox(height: height * 0.01)
                  : SizedBox(height: height * 0.012);
            },
            itemCount: answers.length,
          ),
        ],
      ),
    );
  }
}
