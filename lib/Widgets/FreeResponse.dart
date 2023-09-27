import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Colors_App.dart';

class FreeResponse extends StatefulWidget {
  final String answer;
  final String question;
  final String subQuestion;
  final String boldSubquestion1;
  final String normalSubQuestion1;
  final String boldSubquestion2;
  final String normalSubQuestion2;
  final String boldSubQuestion3;
  final Function changeFilled;
  final Function saveAnswers;

  FreeResponse(
    this.answer,
    this.question,
    this.subQuestion,
    this.boldSubquestion1,
    this.normalSubQuestion1,
    this.boldSubquestion2,
    this.normalSubQuestion2,
    this.boldSubQuestion3,
    this.changeFilled,
    this.saveAnswers,
  );

  @override
  _FreeResponse createState() => _FreeResponse(
        answer,
        question,
        subQuestion,
        boldSubquestion1,
        normalSubQuestion1,
        boldSubquestion2,
        normalSubQuestion2,
        boldSubQuestion3,
        changeFilled,
        saveAnswers,
      );
}

class _FreeResponse extends State<FreeResponse> {
  String question;
  String boldSubquestion1;
  String normalSubQuestion1;
  String boldSubquestion2;
  String normalSubQuestion2;
  String boldSubQuestion3;
  Function changeFilled;
  Function saveAnswers;
  String answer;
  String subQuestion;

  _FreeResponse(
    this.answer,
    this.question,
    this.subQuestion,
    this.boldSubquestion1,
    this.normalSubQuestion1,
    this.boldSubquestion2,
    this.normalSubQuestion2,
    this.boldSubQuestion3,
    this.changeFilled,
    this.saveAnswers,
  );

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    return Container(
      margin: EdgeInsets.symmetric(
        //vertical: height * 0.02,
        horizontal: width * 0.03,
      ),
      child: Column(
        children: [
          question.length > 0
              ? Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.03,
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(
                    question,
                    style: styles.getBlueQuestionTextStyle(),
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(
              top: height * 0.03,
              left: width * 0.03,
            ),
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: subQuestion,
                style: styles.getQuestionTextStyle(),
                children: <TextSpan>[
                  TextSpan(
                    text: boldSubquestion1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: normalSubQuestion1,
                    style: styles.getQuestionTextStyle(),
                  ),
                  TextSpan(
                    text: boldSubquestion2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: normalSubQuestion2,
                    style: styles.getQuestionTextStyle(),
                  ),
                  TextSpan(
                    text: boldSubQuestion3,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            /*Text(
              subQuestion,
              style:styles.getQuestionTextStyle(),
            ),*/
          ),
          Container(
            decoration: BoxDecoration(
              color: greyBG,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(height * 0.003),
            margin: EdgeInsets.only(top: height * 0.02),
            child: TextFormField(
              initialValue: answer,
              // minLines: (height * 0.012).toInt(),
              maxLines: height < 1000
                  ? (height * 0.01).toInt()
                  : height <= 1800
                      ? (height * 0.006).toInt()
                      : (height * 0.004).toInt(),
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
              autocorrect: true,
              onChanged: (value) {
                if (value == "") {
                  changeFilled(false);
                  saveAnswers(value);
                } else {
                  changeFilled(true);
                  saveAnswers(value);
                }
                setState(() {
                  answer = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
