import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YesOrNoType extends StatefulWidget {
  final String answer;
  final String question;
  final String subQuestion;
  final Function changeFilled;
  final Function saveAnswers;

  YesOrNoType(
    this.answer,
    this.question,
    this.subQuestion,
    this.changeFilled,
    this.saveAnswers,
  );

  @override
  _YesOrNoType createState() => _YesOrNoType(
        answer,
        question,
        subQuestion,
        changeFilled,
        saveAnswers,
      );
}

class _YesOrNoType extends State<YesOrNoType> {
  String question;
  Function changeFilled;
  Function saveAnswers;
  String answer;
  String subQuestion;
  Color selected = blueSelected;
  Color unselected = greyBG;

  _YesOrNoType(
    this.answer,
    this.question,
    this.subQuestion,
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
            question.length > 0
                ? Container(
                    margin:
                        EdgeInsets.only(top: height * 0.05, left: width * 0.03),
                    alignment: Alignment.topLeft,
                    child: Text(
                      question,
                      style: styles.getBlueQuestionTextStyle(),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(top: height * 0.03, left: width * 0.03),
              alignment: Alignment.topLeft,
              child: Text(
                subQuestion,
                style: styles.getQuestionTextStyle(),
                //style: styles.getNormalHeadingTextStyle(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        answer = "YES";
                      });
                      saveAnswers("YES");
                      changeFilled(true);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(height * 0.007),
                      height: height * 0.05,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: answer == 'YES' ? selected : unselected,
                        borderRadius: BorderRadius.all(
                          Radius.circular(height * 0.008),
                        ),
                      ),
                      child: Container(
                        child: Text(
                          'YES',
                          style: answer == 'YES'
                              ? styles.getanswersWhiteTextStyle()
                              : styles.getanswersGreyTextStyle(),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        answer = "NO";
                      });
                      saveAnswers("NO");
                      changeFilled(true);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(height * 0.007),
                      height: height * 0.05,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: answer == 'NO' ? selected : unselected,
                        borderRadius: BorderRadius.all(
                          Radius.circular(height * 0.008),
                        ),
                      ),
                      child: Container(
                        child: Text(
                          'NO',
                          style: answer == 'NO'
                              ? styles.getanswersWhiteTextStyle()
                              : styles.getanswersGreyTextStyle(),
                        ),
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
