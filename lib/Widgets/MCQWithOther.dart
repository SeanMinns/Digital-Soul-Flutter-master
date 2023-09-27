import 'package:flutter/cupertino.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';

class MCQWithOther extends StatefulWidget {
  final String other;
  final Function changeOther;
  final List<String> answers;
  final String questions;
  final Function changeFilled;
  final List<bool> mcqs;
  final Function saveAnswer;

  MCQWithOther(
    this.other,
    this.changeOther,
    this.answers,
    this.questions,
    this.changeFilled,
    this.mcqs,
    this.saveAnswer,
  );

  @override
  _MCQWithOtherState createState() => _MCQWithOtherState(
        other,
        changeOther,
        answers,
        questions,
        changeFilled,
        mcqs,
        saveAnswer,
      );
}

class _MCQWithOtherState extends State<MCQWithOther> {
  String other;
  Function changeOther;
  List<String> answers;
  String questions;
  Function changeFilled;
  List<bool> mcqs;
  Function saveAnswer;
  Color selected = blueSelected;
  Color unselected = greyBG;

  _MCQWithOtherState(
    this.other,
    this.changeOther,
    this.answers,
    this.questions,
    this.changeFilled,
    this.mcqs,
    this.saveAnswer,
  );

  bool checkTrue() {
    return mcqs.contains(true);
  }

  @override
  void initState() {
    super.initState();
    if (mcqs.length == 0) {
      for (int i = 0; i < answers.length; i++) {
        mcqs.add(false);
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
            alignment: Alignment.topLeft,
            child: Text(
              questions,
              style: styles.getQuestionTextStyle(),
              textAlign: TextAlign.left,
            ),
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
                child: SizedBox(
                  height: height * 0.055,
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
                        });
                        changeFilled(checkTrue());
                        saveAnswer(mcqs);
                      } else {
                        if (!checkTrue()) {
                          setState(() {
                            mcqs[index] = true;
                          });
                          changeFilled(true);
                          saveAnswer(mcqs);
                        } else {
                          setState(() {
                            int i = mcqs.indexWhere((element) => element);
                            mcqs[i] = false;
                            mcqs[index] = true;
                          });
                          saveAnswer(mcqs);
                          changeFilled(checkTrue());
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
            separatorBuilder: (context, item) {
              return SizedBox(height: height * 0.008);
            },
            itemCount: answers.length,
          ),
          SizedBox(height: height * 0.008),
          mcqs[mcqs.length - 1]
              ? SizedBox(
                  height: height * 0.09,
                  child: TextFormField(
                    initialValue: other,
                    style: styles.getanswersGreyTextStyle(),
                    decoration: InputDecoration(
                      helperText: '',
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
                      hintText: 'Enter Here',
                      hintStyle: styles.getHintTextStyle(),
                      filled: true,
                      fillColor: greyBG,
                    ),
                    onSaved: (value) {},
                    onChanged: (value) {
                      changeOther(value);
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
