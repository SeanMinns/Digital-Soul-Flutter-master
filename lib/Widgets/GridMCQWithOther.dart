import 'package:flutter/cupertino.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';

class GridMCQWithOther extends StatefulWidget {
  final int limit;
  final List<String> answers;
  final String questions;
  final Function changeFilled;
  final List<bool> mcqs;
  final Function saveAnswer;
  final String other;
  final Function saveOther;

  GridMCQWithOther(
    this.limit,
    this.answers,
    this.questions,
    this.changeFilled,
    this.mcqs,
    this.saveAnswer,
    this.other,
    this.saveOther,
  );

  @override
  _GridMCQWithOtherState createState() => _GridMCQWithOtherState(
        limit,
        answers,
        questions,
        changeFilled,
        mcqs,
        saveAnswer,
        other,
        saveOther,
      );
}

class _GridMCQWithOtherState extends State<GridMCQWithOther> {
  int limit;
  List<String> answers;
  String questions;
  Function changeFilled;
  List<bool> mcqs;
  Function saveAnswer;
  List<String> userAnswers = [];
  Color selected = blueSelected;
  Color unselected = greyBG;
  String other;
  Function saveOther;

  _GridMCQWithOtherState(
    this.limit,
    this.answers,
    this.questions,
    this.changeFilled,
    this.mcqs,
    this.saveAnswer,
    this.other,
    this.saveOther,
  );

  bool checkTrue() {
    print(mcqs.contains(true));
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
            child: Text(
              questions,
              style: styles.getQuestionTextStyle(),
            ),
          ),
          SizedBox(height: height * 0.02),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: height * 0.02,
              crossAxisSpacing: width * 0.03,
              mainAxisExtent: height * 0.06,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: mcqs[index] ? selected : unselected,
                ),
                child: SizedBox(
                  height: height * 0.01,
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
                        saveAnswer(mcqs);
                      } else {
                        if (checkLimit()) {
                          setState(() {
                            mcqs[index] = true;
                            userAnswers.add(answers[index]);
                          });
                          if (index != answers.length - 1) {
                            changeFilled(true);
                            saveAnswer(mcqs);
                          }
                        } else {
                          if (userAnswers.length > 0) {
                            setState(() {
                              mcqs[answers.indexOf(
                                  userAnswers[userAnswers.length - 1])] = false;
                              userAnswers.removeAt(userAnswers.length - 1);
                              mcqs[index] = true;
                              userAnswers.add(answers[index]);
                            });
                            saveAnswer(mcqs);
                            changeFilled(checkTrue());
                          }
                        }
                      }
                    },
                    title: Text(
                      answers[index],
                      style: mcqs[index]
                          ? styles.getanswersWhiteTextStyle()
                          : styles.getanswersGreyTextStyle(),
                    ),
                  ),
                ),
              );
            },
            itemCount: answers.length,
          ),
          SizedBox(height: height * 0.02),
          mcqs[mcqs.length - 1]
              ? SizedBox(
                  // height: height * 0.1,
                  child: TextFormField(
                    initialValue: other,
                    style: styles.getanswersGreyTextStyle(),
                    decoration: InputDecoration(
                      // helperText: '',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 10.0,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      hintText: 'Please specify',
                      hintStyle: styles.getHintTextStyle(),
                      filled: true,
                      fillColor: greyBG,
                    ),
                    onSaved: (value) {},
                    onChanged: (value) {
                      saveOther(value);
                      if (value != '') {
                        changeFilled(true);
                      } else {
                        changeFilled(false);
                      }
                    },
                    validator: (String? value) {},
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
