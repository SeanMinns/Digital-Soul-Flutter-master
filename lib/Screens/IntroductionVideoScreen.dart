// import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/VideoWidget.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import '../Widgets/CommonWidgets.dart';
import '../Widgets/navigate_buttons.dart';

class IntroductionVideoScreen extends StatefulWidget {
  const IntroductionVideoScreen({Key? key}) : super(key: key);

  @override
  _IntroductionVideoScreenState createState() =>
      _IntroductionVideoScreenState();
}

class _IntroductionVideoScreenState extends State<IntroductionVideoScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance!.addPostFrameCallback((_) async {
  //     await overlayPopup(
  //       'assets/Star.png',
  //       'You\'re Registered!',
  //       'You can now watch our introduction video and answer 6 questionnaires to help us customise your DigitalSoul.',
  //       'Let’s Get Started',
  //       'POP',
  //       context,
  //     );
  //   });
  // }
  void change(bool ans) {
    print('finish');
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: backGround,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Column(
                children: [
                  Container(
                    color: purpleBG,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.03,
                        ),
                        registerHeading(
                          'Let\'s Watch This',
                          'Please watch this introduction video before we move ahead.',
                          height,
                          width,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  VideoWidget(
                    height,
                    width,
                    change,
                    false,
                    -1,
                  ),
                  Spacer(),
                  NavigateButtons(
                    'PROCEED',
                    'BACK',
                    true,
                    height,
                    width,
                    context,
                    () {
                      Navigator.of(context)
                          .popAndPushNamed(ScreenNavigationConstant.Tutorial);
                    },
                    () {},
                    0,
                    // ScreenNavigationConstant.RegisterScreen2,
                  ),
                  Footer(height, width),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
