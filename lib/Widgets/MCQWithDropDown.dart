import 'package:flutter/cupertino.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:google_fonts/google_fonts.dart';

class MCQWithDropDown extends StatefulWidget {
  final List<String> answers;
  final String answer1;
  final String question1;
  final String answer2;
  final List<List<String>> options;
  final Function changeFilled;
  final Function saveAnswers;

  MCQWithDropDown(
    this.answers,
    this.answer1,
    this.question1,
    this.answer2,
    this.options,
    this.changeFilled,
    this.saveAnswers,
  );

  @override
  _MCQWithDropDown createState() => _MCQWithDropDown(
        answer1,
        answers,
        question1,
        answer2,
        options,
        changeFilled,
        saveAnswers,
      );
}

class _MCQWithDropDown extends State<MCQWithDropDown>
    with SingleTickerProviderStateMixin {
  String answer1;
  List<String> answers;
  String question1;
  String answer2;
  List<List<String>> options;
  Function changeFilled;
  Color selected = blueSelected;
  Color unselected = greyBG;
  List<String> userAnswers = [];
  Function saveAnswers;
  String? dropdownValue;
  // GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  int selectedIndex = -1;
  // late AnimationController _animationController;
  late String title;
  _MCQWithDropDown(
    this.answer1,
    this.answers,
    this.question1,
    this.answer2,
    this.options,
    this.changeFilled,
    this.saveAnswers,
  );

  @override
  void initState() {
    title = (answer2 != '') ? answer2 : 'Please pick one';
    selectedIndex = (answer1 != '') ? answers.indexOf(answer1) : -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * 0.02,
        horizontal: width * 0.06,
      ),
      child: Column(
        children: [
          Container(
            child: Text(
              question1,
              style: styles.getQuestionTextStyle(),
            ),
          ),
          SizedBox(height: height * 0.02),
          Container(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: answer1 == answers[index] ? selected : unselected,
                  ),
                  // height: height * 0.06,
                  child: ListTile(
                    dense: true,
                    tileColor:
                        answer1 == answers[index] ? selected : unselected,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      if (answer1 == answers[index]) {
                        setState(() {
                          answer1 = '';
                          answer2 = '';
                          selectedIndex = -1;
                          title = 'Please pick one';
                        });
                        changeFilled(false);
                        saveAnswers(answer1, answer2);
                      } else {
                        if (selectedIndex == -1)
                          setState(() {
                            answer1 = answers[index];
                            selectedIndex = index;
                            overlayPopup(options[selectedIndex], context);
                          });
                        else {
                          setState(() {
                            answer1 = answers[index];
                            answer2 = '';
                            selectedIndex = index;
                            overlayPopup(options[selectedIndex], context);
                          });
                          changeFilled(false);
                          saveAnswers(answer1, answer2);
                        }
                      }
                    },
                    title: Text(
                      answers[index],
                      style: answer1 == answers[index]
                          ? styles.getanswersWhiteTextStyle()
                          : styles.getanswersGreyTextStyle(),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, item) {
                return SizedBox(height: height * 0.01);
              },
              itemCount: answers.length,
            ),
          ),
          answer2 != '' ? SizedBox(height: height * 0.04) : Container(),
          answer2 != ''
              ? Material(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      overlayPopup(options[selectedIndex], context);
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: greyBG,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(height * 0.01),
                              margin: EdgeInsets.only(left: width * 0.03),
                              child: Text(
                                answer2,
                                style: styles.getNormalTextStyle(),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: greyAnswers,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> overlayPopup(
    List<String> options,
    BuildContext context,
  ) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    return showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(height * 0.01),
                margin:
                    EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                color: Colors.white,
                height: height * 0.9,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 9,
                          child: Text(
                            ('Pick a ' + answer1)
                                .substring(0, ('Pick a ' + answer1).length - 1),
                            style: GoogleFonts.nunito(
                              color: textDarkgrey,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            color: textDarkgrey,
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0.0),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: answer2 == options[index]
                                  ? selected
                                  : unselected,
                            ),
                            // height: height * 0.06,
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: width * 0.02,
                                  right: width * 0.02,
                                  top: height * 0.01,
                                  bottom: height * 0.01),
                              dense: true,
                              tileColor: answer2 == options[index]
                                  ? selected
                                  : unselected,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onTap: () {
                                if (answer2 == options[index]) {
                                } else {
                                  setState(() {
                                    answer2 = options[index];
                                    changeFilled(true);
                                    saveAnswers(answer1, answer2);
                                    Navigator.of(ctx).pop();
                                  });
                                }
                              },
                              title: Text(
                                options[index],
                                style: answer2 == options[index]
                                    ? styles.getanswersWhiteTextStyle()
                                    : styles.getanswersGreyTextStyle(),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, item) {
                          return SizedBox(height: height * 0.01);
                        },
                        itemCount: options.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
