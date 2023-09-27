import 'package:flutter/cupertino.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';

class IconMCQ extends StatefulWidget {
  final List<String> answers;
  final List<String> images;
  final String answer;
  final String questions;
  final Function changeFilled;
  final Function saveMcqAnswers;

  IconMCQ(
    this.answer,
    this.answers,
    this.images,
    this.questions,
    this.changeFilled,
    this.saveMcqAnswers,
  );

  @override
  _IconMCQ createState() => _IconMCQ(
        answer,
        answers,
        images,
        questions,
        changeFilled,
        saveMcqAnswers,
      );
}

class _IconMCQ extends State<IconMCQ> {
  String answer;
  List<String> answers;
  List<String> images;
  String questions;
  Function changeFilled;
  Color selected = blueSelected;
  Color unselected = greyBG;
  Function saveMcqAnswers;

  _IconMCQ(
    this.answer,
    this.answers,
    this.images,
    this.questions,
    this.changeFilled,
    this.saveMcqAnswers,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * 0.01,
        horizontal: width * 0.06,
      ),
      child: Column(
        children: [
          Container(
            child: Text(
              questions,
              style: styles.getQuestionTextStyle(),
            ),
          ),
          SizedBox(height: height * 0.03),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: height * 0.02,
              crossAxisSpacing: width * 0.03,
              mainAxisExtent: height * 0.15,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Container(
                  height: height * 0.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: answers[index] == answer ? selected : unselected,
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              answers[index] == answer ? selected : unselected,
                        ),
                        height: height * 0.08,
                        child: Image.asset(
                          images[index],
                          scale: height >= 920 || width >= 400 ? 1.4 : 0.65,
                        ),
                      ),
                      // SizedBox(
                      //   height: height * 0.001,
                      // ),
                      Text(
                        answers[index],
                        style: answers[index] == answer
                            ? styles.getNormalWhiteTextStyle()
                            : styles.getNormalHeadingTextStyle(),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (answers[index] == answer) {
                    setState(() {
                      answer = "";
                    });
                    changeFilled(false);
                    saveMcqAnswers(answer);
                  } else {
                    setState(() {
                      answer = answers[index];
                    });
                    changeFilled(true);
                    saveMcqAnswers(answer);
                  }
                },
              );
            },
            itemCount: answers.length,
          ),
        ],
      ),
    );
  }
}
