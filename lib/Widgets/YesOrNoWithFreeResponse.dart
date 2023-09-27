import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YesOrNoWithFreeResponse extends StatefulWidget {
  final String answer1;
  final String answer2;
  final String question;
  final String question2;
  final Function changeFilled;
  final Function saveAnswers;

  YesOrNoWithFreeResponse(
    this.answer1,
    this.answer2,
    this.question,
    this.question2,
    this.changeFilled,
    this.saveAnswers,
  );

  @override
  _YesOrNoTypeWithFreeResponse createState() => _YesOrNoTypeWithFreeResponse(
        answer1,
        answer2,
        question,
        question2,
        changeFilled,
        saveAnswers,
      );
}

class _YesOrNoTypeWithFreeResponse extends State<YesOrNoWithFreeResponse> {
  String question;
  Function changeFilled;
  Function saveAnswers;
  String answer1;
  String answer2;
  String question2;
  Color selected = redSelected;
  Color unselected = Colors.white;

  _YesOrNoTypeWithFreeResponse(
    this.answer1,
    this.answer2,
    this.question,
    this.question2,
    this.changeFilled,
    this.saveAnswers,
  );

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    return Scaffold(
      backgroundColor: backGround,
      body: Container(
        margin: EdgeInsets.symmetric(
          //vertical: height * 0.02,
          horizontal: width * 0.02,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.03, left: width * 0.03),
              alignment: Alignment.topLeft,
              child: Text(
                question,
                style: styles.getQuestionTextStyle(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        answer1 = "YES";
                      });
                      saveAnswers(answer1, answer2);
                      if (answer2 != '') {
                        changeFilled(true);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(height * 0.007),
                      height: height * 0.05,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: answer1 == 'YES' ? selected : unselected,
                        borderRadius: BorderRadius.all(
                          Radius.circular(height * 0.008),
                        ),
                      ),
                      child: Container(
                        child: Text(
                          'YES',
                          style: answer1 == 'YES'
                              ? styles.getanswersWhiteTextStyle()
                              : styles.getanswersGreyTextStyle(),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        answer1 = "NO";
                      });
                      saveAnswers(answer1, answer2);
                      if (answer2 != '') {
                        changeFilled(true);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(height * 0.007),
                      height: height * 0.05,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: answer1 == 'NO' ? selected : unselected,
                        borderRadius: BorderRadius.all(
                          Radius.circular(height * 0.008),
                        ),
                      ),
                      child: Container(
                        child: Text(
                          'NO',
                          style: answer1 == 'NO'
                              ? styles.getanswersWhiteTextStyle()
                              : styles.getanswersGreyTextStyle(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.03, left: width * 0.03),
              alignment: Alignment.topLeft,
              child: Text(
                question2,
                style: styles.getQuestionTextStyle(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(height * 0.003),
              margin: EdgeInsets.only(top: height * 0.03),
              child: TextFormField(
                initialValue: answer2,
                // minLines: (height * 0.012).toInt(),
                maxLines: (height * 0.01).toInt(),
                decoration: InputDecoration(
                  hintText: "Please write ",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: width * 0.017, top: height * 0.02),
                  hintStyle: styles.getsmallGreyTextStyle(),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                style: styles.getNormalTextStyle(),
                onChanged: (value) {
                  if (value == "") {
                    changeFilled(false);
                    saveAnswers(answer1, value);
                  } else {
                    if (answer1 != '') {
                      changeFilled(true);
                    }
                    saveAnswers(answer1, value);
                  }
                  setState(() {
                    answer2 = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
