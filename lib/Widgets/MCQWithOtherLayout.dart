import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:flutter/cupertino.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:google_fonts/google_fonts.dart';

class MCQWithOtherLayout extends StatefulWidget {
  final String other;
  final Function changeOther;
  final List<String> answers;
  final String questions;
  final Function changeFilled;
  final List<bool> mcqs;
  final Function saveAnswer;

  MCQWithOtherLayout(
    this.other,
    this.changeOther,
    this.answers,
    this.questions,
    this.changeFilled,
    this.mcqs,
    this.saveAnswer,
  );

  @override
  _MCQWithOtherLayoutState createState() => _MCQWithOtherLayoutState(
        other,
        changeOther,
        answers,
        questions,
        changeFilled,
        mcqs,
        saveAnswer,
      );
}

class _MCQWithOtherLayoutState extends State<MCQWithOtherLayout> {
  String other;
  Function changeOther;
  List<String> answers;
  String questions;
  Function changeFilled;
  List<bool> mcqs;
  Function saveAnswer;
  Color selected = blueSelected;
  Color unselected = greyBG;

  _MCQWithOtherLayoutState(
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

  Future<void> openDialogAdd(
    BuildContext context,
    Style styles,
    double height,
    double width,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: height * 0.65,
            width: height < 1000 ? width : width * 0.5,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '',
                  style: GoogleFonts.nunito(
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(80, 83, 89, 1),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TextFormField(
                    initialValue: other,
                    maxLines: height <= 1000
                        ? (height * 0.015).toInt()
                        : (height * 0.01).toInt(),
                    style: styles.getNormalTextStyle(),
                    decoration: InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      fillColor: Color.fromRGBO(244, 244, 244, 1),
                      hintText: "Please specify ... ",
                      hintStyle: styles.getsmallGreyTextStyle(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) {},
                    onChanged: (value) {
                      other = value;
                      changeOther(value);
                    },
                    validator: (String? value) {},
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                    top: height * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                        },
                        child: Ink(
                          height: 0.06 * height,
                          width: 0.2 * width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Back',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(ctx);
                          },
                          child: Ink(
                            height: 0.06 * height,
                            width: checkTablet(height, width)
                                ? width * 0.2
                                : 0.25 * width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              color: buttonColor,
                            ),
                            child: Center(
                              child: Text(
                                'DONE',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
                        if (index + 1 == mcqs.length) {
                          openDialogAdd(context, styles, height, width);
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
        ],
      ),
    );
  }
}
