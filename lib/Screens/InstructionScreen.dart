import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:flutter/material.dart';
import '../Widgets/CommonWidgets.dart';

class InstructionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InstructionScreen();
  }
}

class _InstructionScreen extends State<InstructionScreen> {
  double pos = 0;
  List images = tutorial;

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: purpleBG,
          body: Container(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Image.asset(
                  'assets/instruction.png',
                  height: height * 0.23,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.08),
                  child: Text(
                    'The following items deal with ways people cope with negative life events. Please indicate how much or how frequently you use each method. Don’t answer on the basis of what works for you – just whether or not you tend to use each method.',
                    textAlign: TextAlign.center,
                    style: styles.getPopUpMainTextStyle(1),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.popAndPushNamed(context, ScreenNavigationConstant.Set2Screen);
                  },
                  child: Container(
                    height: 0.06 * height,
                    width: 0.4 * width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      color: buttonColor,
                    ),
                    child: Center(
                      child: Text(
                        'GOT IT!',
                        style: styles.getPopUpButtonTextStyle(),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Footer(height, width),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
