import 'dart:ui';

import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_diary.dart';
import 'package:intl/intl.dart';

List emotionAssets = [
  'assets/emotion1.png',
  'assets/emotion2.png',
  'assets/emotion3.png',
  'assets/emotion4.png',
  'assets/emotion5.png',
  'assets/emotion6.png',
];

List stressAssets = [
  'assets/stress1.png',
  'assets/stress2.png',
  'assets/stress3.png',
  'assets/stress4.png',
  'assets/stress5.png',
  'assets/stress6.png',
];

class PrayerDiaryScreen extends StatefulWidget {
  const PrayerDiaryScreen({Key? key}) : super(key: key);

  @override
  _PrayerDiaryScreenState createState() => _PrayerDiaryScreenState();
}

class _PrayerDiaryScreenState extends State<PrayerDiaryScreen> {
  bool _isInit = true;
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
  void didChangeDependencies() async {
    if (_isInit) {
      try {
        setState(() {
          _isLoading = true;
        });
        showOverlay(false, context);
        await Provider.of<Diary>(context, listen: false).getEntries();
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
      } on HttpException catch (_) {
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        await overlayPopup(
          'assets/server_error.png',
          'Oops!',
          'There seems to be an internal server error. Please try again in some time.',
          'OKAY',
          context,
          0.9,
        );
        Navigator.of(context).pop();
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        showOverlay(true, context);
        print(error);
        bool isOnline = await hasNetwork();
        if (!isOnline) {
          await overlayPopup(
            'assets/no_internet.png',
            'No Internet!',
            'Please check if you have proper internet connection to continue.',
            'OKAY',
            context,
            0.9,
          );
          Navigator.of(context).pop();
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
    _overlayEntry = moreOverlay(buttonPosition, buttonSize, false, -1, () {
      setState(() {
        closeMenu();
      });
    }, context);
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    List<Entry> diary = Provider.of<Diary>(context, listen: false).diary;
    List<Entry> recentEntries = diary
        .where((entry) => DateTime.now().difference(entry.date!).inDays <= 30)
        .toList();
    List<Entry> pastEntries = diary
        .where((entry) => DateTime.now().difference(entry.date!).inDays > 30)
        .toList();
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Opacity(
            opacity: _isLoading ? 0.3 : 1,
            child: IgnorePointer(
              ignoring: _isLoading,
              child: Container(
                color: backGround,
                child: Column(
                  children: [
                    Container(
                      color: darkBlue,
                      height: height * 0.3,
                      padding: EdgeInsets.only(top: height * 0.02),
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
                            margin: EdgeInsets.only(top: height * 0.01),
                            child: Text(
                              "Your Prayer Diary",
                              style: styles.getWhiteHeading(),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isMenuOpen) closeMenu();
                              });
                              Navigator.of(context).pushNamed(
                                  ScreenNavigationConstant
                                      .NewPrayerEntryScreen);
                            },
                            child: Container(
                              height: 0.06 * height,
                              width: 0.45 * width,
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
                                      'assets/prayericon.png',
                                      scale: height >= 920 ? 5 : 6.3,
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    Text(
                                      'NEW ENTRY',
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
                    Container(
                      height: height * 0.6,
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: height * 0.05,
                        ),
                        children: [
                          recentEntries.length != 0
                              ? Text(
                                  'Your Recent Entries',
                                  style: GoogleFonts.nunito(
                                    fontSize: height * 0.025,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Container(),
                          recentEntries.length != 0
                              ? SizedBox(height: height * 0.02)
                              : Container(),
                          recentEntries.length != 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (ctx, i) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isMenuOpen) closeMenu();
                                          });
                                          Navigator.of(context).pushNamed(
                                            ScreenNavigationConstant
                                                .PreviousPrayerEntryScreen,
                                            arguments: {"index": i},
                                          );
                                        },
                                        child: Container(
                                          height: height * 0.25,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            color: Color.fromRGBO(
                                                244, 244, 244, 1),
                                            elevation: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateTime.now().hour > 11
                                                        ? '${DateFormat("E, LLL d, h:mm").format(recentEntries[i].date!)}pm'
                                                        : '${DateFormat("E, LLL d, h:mm").format(recentEntries[i].date!)}am',
                                                    style: GoogleFonts.nunito(
                                                      fontSize: height * 0.015,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          125, 128, 137, 1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'PRAYER TYPE ',
                                                      style: GoogleFonts.nunito(
                                                        fontSize:
                                                            height * 0.015,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: recentEntries[i]
                                                              .prayerType!
                                                              .join(', '),
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize:
                                                                height * 0.02,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.01),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'FEELINGS BEFORE ',
                                                            style: GoogleFonts
                                                                .nunito(
                                                              fontSize: height *
                                                                  0.015,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            height: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    emotionAssets[
                                                                        recentEntries[i].beforeEmotions! -
                                                                            1]),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          Container(
                                                            width: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            height: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    stressAssets[
                                                                        recentEntries[i].beforeStress! -
                                                                            1]),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'FEELINGS AFTER ',
                                                            style: GoogleFonts
                                                                .nunito(
                                                              fontSize: height *
                                                                  0.015,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            height: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    emotionAssets[
                                                                        recentEntries[i].afterEmotions! -
                                                                            1]),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          Container(
                                                            width: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            height: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    stressAssets[
                                                                        recentEntries[i].afterStress! -
                                                                            1]),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  Text(
                                                    recentEntries[i].prayer!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    // maxLines: 2,
                                                    maxLines:
                                                        height <= 590 ? 1 : 2,
                                                    softWrap: true,
                                                    style: GoogleFonts.nunito(
                                                      fontSize: height * 0.02,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          80, 83, 89, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                    ],
                                  ),
                                  itemCount: recentEntries.length,
                                )
                              : Container(),
                          pastEntries.length != 0
                              ? Text(
                                  'Your Past Entries',
                                  style: GoogleFonts.nunito(
                                    fontSize: height * 0.025,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Container(),
                          pastEntries.length != 0
                              ? SizedBox(height: height * 0.02)
                              : Container(),
                          pastEntries.length != 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (ctx, i) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isMenuOpen) closeMenu();
                                          });
                                          Navigator.of(context).pushNamed(
                                            ScreenNavigationConstant
                                                .PreviousPrayerEntryScreen,
                                            arguments: {
                                              "index": i + recentEntries.length
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: height * 0.25,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            color: Color.fromRGBO(
                                                244, 244, 244, 1),
                                            elevation: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateTime.now().hour > 11
                                                        ? '${DateFormat("E, LLL d, h:mm").format(pastEntries[i].date!)}pm'
                                                        : '${DateFormat("E, LLL d, h:mm").format(pastEntries[i].date!)}am',
                                                    style: GoogleFonts.nunito(
                                                      fontSize: height * 0.015,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                        125,
                                                        128,
                                                        137,
                                                        1,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'PRAYER TYPE ',
                                                      style: GoogleFonts.nunito(
                                                        fontSize:
                                                            height * 0.015,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: pastEntries[i]
                                                              .prayerType!
                                                              .join(', '),
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize:
                                                                height * 0.02,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.01),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'FEELINGS BEFORE ',
                                                            style: GoogleFonts
                                                                .nunito(
                                                              fontSize: height *
                                                                  0.015,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            height: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    emotionAssets[
                                                                        pastEntries[i].beforeEmotions! -
                                                                            1]),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          Container(
                                                            width: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            height: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    stressAssets[
                                                                        pastEntries[i].beforeStress! -
                                                                            1]),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'FEELINGS AFTER ',
                                                            style: GoogleFonts
                                                                .nunito(
                                                              fontSize: height *
                                                                  0.015,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            height: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    emotionAssets[
                                                                        pastEntries[i].afterEmotions! -
                                                                            1]),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          Container(
                                                            width: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            height: checkTablet(
                                                                    height,
                                                                    width)
                                                                ? 40
                                                                : 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    stressAssets[
                                                                        pastEntries[i].afterStress! -
                                                                            1]),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  Text(
                                                    pastEntries[i].prayer!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines:
                                                        height <= 590 ? 1 : 2,
                                                    // maxLines: 2,
                                                    softWrap: true,
                                                    style: GoogleFonts.nunito(
                                                      fontSize: height * 0.02,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                        80,
                                                        83,
                                                        89,
                                                        1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                    ],
                                  ),
                                  itemCount: pastEntries.length,
                                )
                              : Container(),
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
      ),
    );
  }
}
