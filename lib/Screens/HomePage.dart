import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/providers/database_helper.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:digital_soul/providers/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInit = true;

  void didChangeDependencies() async {
    if (_isInit) {
      // await DatabaseHelper.instance.deleteAll();
      if (ModalRoute.of(context)!.settings.arguments != null) {
        var data = ModalRoute.of(context)!.settings.arguments
            as Map<String, List<int>>;
        var profileId =
            Provider.of<UserProfile>(context, listen: false).item!.id;
        var getData;
        List<String> answers = [];
        List<int> timer = [];
        for (int j = 1; j < 6; j++) {
          getData = await DatabaseHelper.instance.queryLesson(profileId!, j);
          answers = [];
          timer = [];
          for (int i = 0; i < getData.length; i++) {
            answers.add(getData[i]['answer']);
            timer.add(getData[i]['timer']);
          }
          Provider.of<Lessons>(context, listen: false)
              .setLessons('$j', answers, timer, data['progress']!);
        }
        _isInit = false;
      }
    }
    super.didChangeDependencies();
  }

  void buttonFunction(UserProfile userProfile, Lessons lessons) {
    userProfile.signOut();
    lessons.clearLessons();
    Navigator.of(context).pop();
    Navigator.of(context).popAndPushNamed(ScreenNavigationConstant.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);
    Lessons lessons = Provider.of<Lessons>(context, listen: false);
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    print('height: ' + height.toString());
    print('width: ' + width.toString());
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: backGround,
            child: Column(
              children: [
                Container(
                  color: darkBlue,
                  height: height * 0.2,
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(
                          bottom: height * 0.01,
                          right: width * 0.02,
                        ),
                        child: GestureDetector(
                          child: Text(
                            "Logout",
                            style: styles.getsmallGreyTextStyle(),
                          ),
                          onTap: () {
                            overlayPopup2(
                              'assets/Logout.png',
                              'Are You Sure?',
                              'We hope you return soon enough to try out the lessons or to make a new diary entry.',
                              'LOGOUT',
                              () => buttonFunction(userProfile, lessons),
                              context,
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.03),
                        child: Text(
                          "Welcome ${userProfile.item!.firstName}",
                          style: styles.getWhiteHeading(),
                        ),
                      ),
                      Container(
                        child: Text(
                          "What would you like to do today?",
                          style: styles.getNormalWhiteTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    //margin: EdgeInsets.only(left: width*0.06,right: width*0.09),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            ScreenNavigationConstant.PickLessonScreen);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/pickLesson.png',
                              scale: checkTablet(height, width) ? 1.2 : 2),
                          /*SvgPicture.asset(
                            'assets/pickLesson.svg',
                          ),*/
                          Text(
                            "PICK A \nLESSON",
                            style: styles.getDarkGreyHeading(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    //margin: EdgeInsets.only(top:hei,left: width*0.01,right: width*0.06),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            ScreenNavigationConstant.PrayerDiaryScreen);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /*SvgPicture.asset(
                            'assets/prayerDiary.svg',
                          ),*/
                          Image.asset(
                            'assets/prayerDiary.png',
                            scale: checkTablet(height, width) ? 1.2 : 2,
                          ),
                          Text(
                            "PRAYER \nDIARY",
                            style: styles.getDarkGreyHeading(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Footer(height, width),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
