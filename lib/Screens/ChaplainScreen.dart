import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/Widgets/FreeResponse.dart';
import 'package:digital_soul/Widgets/navigate_buttons.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:digital_soul/providers/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Constants/Text_Styles.dart';
import '../Widgets/CommonWidgets.dart';

class ChaplainScreen extends StatefulWidget {
  const ChaplainScreen({Key? key}) : super(key: key);

  @override
  _ChaplainScreenState createState() => _ChaplainScreenState();
}

class _ChaplainScreenState extends State<ChaplainScreen> {
  String message = '';
  bool isFilled = false;
  bool _isLoading = false;
  GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  Icon icon = Icon(Icons.more_horiz);
  OverlayEntry entry = loading();

  void showOverlay(bool isLoading, BuildContext context) {
    if (isLoading == false) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => Overlay.of(context)!.insert(entry));
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) => entry.remove());
    }
  }

  @override
  void initState() {
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    if (isMenuOpen) _overlayEntry!.remove();
    //_animationController.dispose();
    entry.dispose();
    super.dispose();
  }

  findButton() {
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry!.remove();
    icon = Icon(Icons.more_horiz);
    //  _animationController.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    //   _animationController.forward();
    icon = Icon(Icons.close);
    _overlayEntry = moreOverlay(buttonPosition, buttonSize, false, 0, () {
      setState(() {
        closeMenu();
      });
    }, context);
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  void changeIsFilled(bool value) {
    setState(() {
      isFilled = value;
    });
  }

  void saveFreeResponseAnswer(String value) {
    message = value;
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    var profile = Provider.of<UserProfile>(context, listen: false).item;
    var color =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Opacity(
              opacity: _isLoading ? 0.3 : 1,
              child: IgnorePointer(
                ignoring: _isLoading,
                child: SizedBox(
                  height: height,
                  child: Container(
                    color: backGround,
                    child: Column(
                      children: [
                        Container(
                          color: color['color'],
                          height: height * 0.2,
                          padding: EdgeInsets.only(top: height * 0.01),
                          child: Column(
                            children: [
                              Container(
                                key: _key,
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(
                                  right: width * 0.02,
                                ),
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Image.asset('assets/hamburger.png'),
                                  onPressed: () {
                                    setState(() {
                                      if (isMenuOpen) {
                                        closeMenu();
                                      } else {
                                        openMenu();
                                      }
                                    });
                                  },
                                ),
                              ),
                              Container(
                                //margin: EdgeInsets.only(top: height * 0.01),
                                child: Text(
                                  "Write to Chaplain",
                                  style: styles.getBlueHeading(),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.005),
                                child: Text(
                                  "What would you like to talk about?",
                                  style: styles.getNormalTextStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.6,
                          child: FreeResponse(
                            message,
                            '',
                            'You can send Mclean\'s Chaplains a secure message below, after getting your message the Chaplain will privately contact you outside of the app to address your spiritual concern.',
                            "",
                            "",
                            "",
                            "",
                            "",
                            changeIsFilled,
                            saveFreeResponseAnswer,
                          ),
                        ),
                        Spacer(),
                        NavigateButtons(
                          'SEND',
                          'HOME',
                          isFilled,
                          height,
                          width,
                          context,
                          () async {
                            try {
                              setState(() {
                                if (isMenuOpen) closeMenu();
                                _isLoading = true;
                              });
                              showOverlay(false, context);
                              await Provider.of<Lessons>(context, listen: false)
                                  .sendEmailToChaplain(
                                profile!.id!,
                                profile.email!,
                                message,
                              );
                              setState(() {
                                _isLoading = false;
                              });
                              showOverlay(true, context);
                              if (color['number'] == '1') {
                                await overlayPopup(
                                  'assets/LessonEndPopup.png',
                                  'You\'re Done!',
                                  'Now that you\'ve completed this lesson, you can get started with another or make a diary entry.',
                                  'HOMESCREEN',
                                  context,
                                  1,
                                );
                              }
                              if (color['number'] == '5') {
                                await overlayPopup(
                                  'assets/LessonEndPopup2.png',
                                  'Well Done, ${profile.firstName}!',
                                  'You have completed all 5 lessons. You can attempt a lesson again when you’re ready!',
                                  'HOMESCREEN',
                                  context,
                                  1,
                                );
                              }
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(
                                  ScreenNavigationConstant.homeScreen);
                            } on HttpException catch (_) {
                              setState(() {
                                _isLoading = false;
                              });
                              showOverlay(true, context);
                              overlayPopup(
                                'assets/server_error.png',
                                'Oops!',
                                'There seems to be an internal server error. Please try again in some time.',
                                'OKAY',
                                context,
                                0.9,
                              );
                            } catch (error) {
                              setState(() {
                                _isLoading = false;
                              });
                              showOverlay(true, context);
                              print(error);
                              bool isOnline = await hasNetwork();
                              if (!isOnline) {
                                overlayPopup(
                                  'assets/no_internet.png',
                                  'No Internet!',
                                  'Please check if you have proper internet connection to continue.',
                                  'OKAY',
                                  context,
                                  0.9,
                                );
                              }
                            }
                          },
                          () {
                            setState(() {
                              if (isMenuOpen) closeMenu();
                            });
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushNamed(ScreenNavigationConstant.homeScreen);
                          },
                          1,
                        ),
                        Footer(height, width),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
