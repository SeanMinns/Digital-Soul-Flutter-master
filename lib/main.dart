import 'package:digital_soul/Screens/HomePage.dart';
import 'package:digital_soul/Screens/InstructionScreen.dart';
import 'package:digital_soul/Screens/NewDiaryEntry.dart';
import 'package:digital_soul/Screens/PickLesson.dart';
import 'package:digital_soul/Screens/Set1Screen.dart';
import 'package:digital_soul/Screens/SetScreen2.dart';
import 'package:digital_soul/Screens/TutorialScreen.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:digital_soul/providers/sets.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Constants/Colors_App.dart';
import 'Constants/Screen_Navigation.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/IntroductionVideoScreen.dart';
import 'Screens/RegisterScreen1.dart';
import 'Screens/RegisterScreen2.dart';
import 'Screens/RegisterScreen3.dart';
import 'Screens/PrayerDiaryScreen.dart';
import 'Screens/PreviousPrayerEntryScreen.dart';
import 'Screens/Lesson1Screen.dart';
import 'Screens/Lesson2Screen.dart';
import 'Screens/Lesson3Screen.dart';
import 'Screens/Lesson4Screen.dart';
import 'Screens/Lesson5Screen.dart';
import 'Screens/ChaplainScreen.dart';
import 'Screens/PopupLessonScreen.dart';
import 'Screens/ForgotPassword.dart';
import 'Screens/ForgotPassword2.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import './providers/profile.dart';
import './providers/prayer_diary.dart';

// Generated in previous step
import 'Screens/SetScreen6.dart';
import 'Screens/SetScreen4.dart';
import 'Screens/SetScreen5.dart';
import 'Screens/SetScreen3.dart';
import 'amplifyconfiguration.dart';
// import 'package:device_preview/device_preview.dart';

void main() {
  runApp(MyApp()
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => MyApp(), // Wrap your app
      // ),
      );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  bool flag = false;

  @override
  initState() {
    super.initState();
    if (Amplify.isConfigured == false) {
      _configureAmplify();
    }
  }

  void _configureAmplify() async {
    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugins([authPlugin, analyticsPlugin]);
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        flag = true;
      });
    });

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(e);
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    String initialRoute = ScreenNavigationConstant.loginScreen;
    return (flag)
        ? MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => UserProfile(),
              ),
              ChangeNotifierProxyProvider<UserProfile, Diary>(
                create: (ctx) => Diary(null, null, []),
                update: (ctx, profile, previousDiary) => Diary(
                  profile.token,
                  profile.item != null ? profile.item!.id : null,
                  previousDiary == null ? [] : previousDiary.diary,
                ),
              ),
              ChangeNotifierProxyProvider<UserProfile, Lessons>(
                create: (ctx) => Lessons(null, null, [], []),
                update: (ctx, profile, previousLessons) => Lessons(
                  profile.token,
                  profile.item != null ? profile.item!.id : null,
                  previousLessons == null ? [] : previousLessons.lessons,
                  previousLessons == null ? [] : previousLessons.progress,
                ),
              ),
              ChangeNotifierProxyProvider<UserProfile, Sets>(
                create: (ctx) => Sets(null, null, []),
                update: (ctx, profile, previousSets) => Sets(
                  profile.token,
                  profile.item != null ? profile.item!.id : null,
                  previousSets == null ? [] : previousSets.sets,
                ),
              ),
            ],
            child: MaterialApp(
              // locale: DevicePreview.locale(context), // Add the locale here
              // builder: DevicePreview.appBuilder,
              color: backGround,
              initialRoute: initialRoute,
              debugShowCheckedModeBanner: false,
              routes: {
                ScreenNavigationConstant.loginScreen: (context) =>
                    LoginScreen(),
                ScreenNavigationConstant.IntroductionVideoScreen: (context) =>
                    IntroductionVideoScreen(),
                ScreenNavigationConstant.RegisterScreen1: (context) =>
                    RegisterScreen1(),
                ScreenNavigationConstant.RegisterScreen2: (context) =>
                    RegisterScreen2(),
                ScreenNavigationConstant.RegisterScreen3: (context) =>
                    RegisterScreen3(),
                ScreenNavigationConstant.homeScreen: (context) => HomePage(),
                ScreenNavigationConstant.PrayerDiaryScreen: (context) =>
                    PrayerDiaryScreen(),
                ScreenNavigationConstant.PreviousPrayerEntryScreen: (context) =>
                    PreviousPrayerEntryScreen(),
                ScreenNavigationConstant.NewPrayerEntryScreen: (context) =>
                    NewDiaryEntry(),
                ScreenNavigationConstant.PickLessonScreen: (context) =>
                    PickLesson(),
                ScreenNavigationConstant.Lesson1Screen: (context) =>
                    Lesson1Screen(),
                ScreenNavigationConstant.Lesson2Screen: (context) =>
                    Lesson2Screen(),
                ScreenNavigationConstant.Lesson3Screen: (context) =>
                    Lesson3Screen(),
                ScreenNavigationConstant.Lesson4Screen: (context) =>
                    Lesson4Screen(),
                ScreenNavigationConstant.Lesson5Screen: (context) =>
                    Lesson5Screen(),
                ScreenNavigationConstant.ChaplainScreen: (context) =>
                    ChaplainScreen(),
                ScreenNavigationConstant.PopupLessonScreen: (context) =>
                    PopupLessonScreen(),
                ScreenNavigationConstant.Set1Screen: (context) => Set1Screen(),
                ScreenNavigationConstant.Set2Screen: (context) => SetScreen2(),
                ScreenNavigationConstant.Set3Screen: (context) => SetScreen3(),
                ScreenNavigationConstant.Set4Screen: (context) => SetScreen4(),
                ScreenNavigationConstant.Set5Screen: (context) => SetScreen5(),
                ScreenNavigationConstant.Set6Screen: (context) => SetScreen6(),
                ScreenNavigationConstant.Tutorial: (context) =>
                    TutorialScreen(),
                ScreenNavigationConstant.Instruction: (context) =>
                    InstructionScreen(),
                ScreenNavigationConstant.ForgotPassword1: (context) =>
                    ForgotPassword1(),
                ScreenNavigationConstant.ForgotPassword2: (context) =>
                    ForgotPassword2(""),
              },
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            // locale: DevicePreview.locale(context), // Add the locale here
            // builder: DevicePreview.appBuilder,
            home: Scaffold(
              backgroundColor: purpleBG,
              body: Center(child: Image.asset('assets/splashscreen.png')),
            ),
          );
  }
}
