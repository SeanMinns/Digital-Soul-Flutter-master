import 'package:flutter/cupertino.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';

class DropDownWithFreeResponse extends StatefulWidget {
  final List<String> answers;
  final String answer1;
  final String question1;
  final String answer2;
  final String question2;
  final Function changeFilled;
  final Function saveAnswers;

  DropDownWithFreeResponse(
    this.answers,
    this.answer1,
    this.question1,
    this.answer2,
    this.question2,
    this.changeFilled,
    this.saveAnswers,
  );

  @override
  _DropDownWithFreeResponse createState() => _DropDownWithFreeResponse(
        answer1,
        answers,
        question1,
        answer2,
        question2,
        changeFilled,
        saveAnswers,
      );
}

class _DropDownWithFreeResponse extends State<DropDownWithFreeResponse>
    with SingleTickerProviderStateMixin {
  String answer1;
  List<String> answers;
  String question1;
  String answer2;
  String question2;
  Function changeFilled;
  Color selected = redSelected;
  Color unselected = Colors.transparent;
  List<String> userAnswers = [];
  Function saveAnswers;
  String? dropdownValue;
  GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  BorderRadius? _borderRadius;
  Icon icon = Icon(Icons.arrow_drop_down);
  late String title;
  _DropDownWithFreeResponse(
    this.answer1,
    this.answers,
    this.question1,
    this.answer2,
    this.question2,
    this.changeFilled,
    this.saveAnswers,
  );

  @override
  void initState() {
    title = (answer1 != '') ? answer1 : 'Please pick one';
    _borderRadius = BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    if (isMenuOpen) _overlayEntry!.remove();

    super.dispose();
  }

  findButton() {
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry!.remove();
    icon = Icon(Icons.arrow_drop_down);
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    icon = Icon(Icons.arrow_drop_up);
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
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
          InkWell(
            onTap: () {
              setState(() {
                if (isMenuOpen) {
                  closeMenu();
                } else {
                  openMenu();
                }
              });
            },
            child: Container(
              key: _key,
              decoration: BoxDecoration(
                color: greyBG,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(height * 0.003),
                      margin: EdgeInsets.only(left: width * 0.03),
                      child: Text(
                        title,
                        style: styles.getNormalTextStyle(),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: icon,
                    color: greyAnswers,
                    onPressed: () {
                      if (isMenuOpen) {
                        closeMenu();
                      } else {
                        openMenu();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          (title != "Please pick one")
              ? Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(
                    question2,
                    style: styles.getQuestionTextStyle(),
                  ),
                )
              : Container(),
          (title != "Please pick one")
              ? SizedBox(height: height * 0.01)
              : Container(),
          (title != "Please pick one")
              ? Container(
                  decoration: BoxDecoration(
                    color: greyBG,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(width * 0.02),
                  margin: EdgeInsets.only(top: height * 0.01),
                  child: TextFormField(
                    initialValue: answer2,
                    // minLines: (height * 0.012).toInt(),
                    maxLines: height < 1000
                        ? (height * 0.008).toInt()
                        : height <= 1800
                            ? (height * 0.0047).toInt()
                            : (height * 0.0028).toInt(),
                    decoration: InputDecoration.collapsed(
                      hintText: "Please write up to 3 sentences",
                      hintStyle: styles.getsmallGreyTextStyle(),
                    ),
                    style: styles.getNormalTextStyle(),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      if (value == "") {
                        changeFilled(false);
                        saveAnswers(title, value);
                      } else {
                        changeFilled(true);
                        saveAnswers(title, value);
                      }
                      setState(() {
                        answer2 = value;
                      });
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        Style styles = new Style(height, width);
        return Positioned(
          top: buttonPosition!.dy + buttonSize!.height,
          left: buttonPosition!.dx,
          width: buttonSize!.width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              // height: height * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: _borderRadius,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0.0),
                itemCount: answers.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        title = answers[index];
                      });
                      // changeFilled(true);
                      saveAnswers(answers[index], answer2);
                      closeMenu();
                    },
                    child: Container(
                      color: title == answers[index] ? selected : unselected,
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.0,
                            width: width,
                            color: Colors.black26,
                          ),
                          Container(
                            height: height * 0.05,
                            padding: EdgeInsets.only(left: width * 0.03),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              answers[index],
                              style: title == answers[index]
                                  ? styles.getanswersWhiteTextStyle()
                                  : styles.getanswersGreyTextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
