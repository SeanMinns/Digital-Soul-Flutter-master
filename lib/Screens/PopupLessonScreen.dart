import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:flutter/material.dart';
import '../Constants/Text_Styles.dart';

class PopupLessonScreen extends StatefulWidget {
  const PopupLessonScreen({Key? key}) : super(key: key);

  @override
  State<PopupLessonScreen> createState() => _PopupLessonScreenState();
}

class _PopupLessonScreenState extends State<PopupLessonScreen> {
  GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  OverlayEntry? _overlayEntry;
  Offset? buttonPosition;
  Size? buttonSize;
  Icon icon = Icon(Icons.more_horiz);

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
    _overlayEntry = moreOverlay(buttonPosition, buttonSize, false, -1,() {
      setState(() {
        closeMenu();
      });
    }, context);
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    var image =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: height * 0.9,
                    color: textBlue,
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
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Container(
                          // child: SvgPicture.asset(
                          //   image['route']!,
                          //   height: height * 0.34,
                          // ),
                          child: Image.asset(
                            image['route']!,
                            scale: checkTablet(height, width) ? 2.0 : 3.2,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          'Lesson Complete!',
                          style: styles.getPopUpMainTextStyle(2),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.08),
                          child: Text(
                            'DigitalSoul is a starting point for integrating spirituality into your treatment. If you found today\'s session helpful, you\'re encouraged to speak about it with your therapist, or with our hospital Chaplain.',
                            style: styles.getPopUpSubTextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushNamed(ScreenNavigationConstant.homeScreen);
                          },
                          child: Container(
                            height: 0.06 * height,
                            width: 0.5 * width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              color: buttonColor,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/popupscreen2.png',
                                    scale: checkTablet(height, width) ? 5 : 6.3,
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Text(
                                    'HOMESCREEN',
                                    style: styles.getPopUpButtonTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).popAndPushNamed(
                              ScreenNavigationConstant.ChaplainScreen,
                              arguments: {
                                'color': image['color'],
                                'number': image['number'],
                              },
                            );
                          },
                          child: Container(
                            height: 0.06 * height,
                            width: 0.5 * width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              color: buttonColor,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/popupscreen1.png',
                                    scale: checkTablet(height, width) ? 5 : 6.3,
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Text(
                                    'CHAPLAIN',
                                    style: styles.getPopUpButtonTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
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
