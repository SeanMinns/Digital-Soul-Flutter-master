import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:flutter/cupertino.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';

import 'CommonWidgets.dart';

class AddPrayer extends StatefulWidget {
  final List<bool> mcqs;
  final String prayer;
  final Function changeFilled;
  final Function savePrayerAnswer;

  AddPrayer(
    this.mcqs,
    this.prayer,
    this.changeFilled,
    this.savePrayerAnswer,
  );

  @override
  _AddPrayer createState() => _AddPrayer(
        mcqs,
        prayer,
        changeFilled,
        savePrayerAnswer,
      );
}

class _AddPrayer extends State<AddPrayer> {
  List<bool> mcqs;
  String selected = "";
  String prayer;
  Function changeFilled;
  Function savePrayerAnswer;

  _AddPrayer(
    this.mcqs,
    this.prayer,
    this.changeFilled,
    this.savePrayerAnswer,
  );

  @override
  void initState() {
    var i;
    List<String> selectedWords = [];
    for (i = 0; i < mcqs.length; i++) {
      if (mcqs[i]) {
        selectedWords.add(mcqWordQuestionsDiary[i]);
      }
    }
    selected = selectedWords.join(', ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    print(checkTablet(height, width));
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * 0.05,
        horizontal: width * 0.06,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "You selected -",
              style: styles.getQuestionTextStyle(),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              selected,
              style: GoogleFonts.nunito(
                color: textBlue,
                fontSize: height < 1000 ? height * 0.025 : height * 0.035,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "What is your prayer?",
              style: styles.getQuestionTextStyle(),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            decoration: BoxDecoration(
              color: greyBG,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(height * 0.003),
            child: TextFormField(
              initialValue: prayer,
              // minLines: (height * 0.012).toInt(),
              maxLines: checkTablet(height, width)
                  ? (height * 0.006).toInt()
                  : (height * 0.011).toInt(),
              decoration: InputDecoration(
                hintText: "Please write up to 3-4 sentences",
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: width * 0.017, top: height * 0.01),
                hintStyle: styles.getsmallGreyTextStyle(),
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: checkTablet(height, width) ? 33 : 20),
              onChanged: (value) {
                if (value == "") {
                  changeFilled(false);
                  savePrayerAnswer(value);
                } else {
                  changeFilled(true);
                  savePrayerAnswer(value);
                }
                setState(() {
                  prayer = value;
                });
              },
              onFieldSubmitted: (value) {
                // if (prayer == "") {
                //   changeFilled(false);
                //   savePrayerAnswer(value);
                // } else {
                //   changeFilled(true);
                //   savePrayerAnswer(value);
                // }
              },
            ),
          ),
        ],
      ),
    );
  }
}
