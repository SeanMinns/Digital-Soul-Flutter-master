import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/previous_entry_card.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_diary.dart';

class PreviousPrayerEntryScreen extends StatefulWidget {
  const PreviousPrayerEntryScreen({Key? key}) : super(key: key);

  @override
  _PreviousPrayerEntryScreenState createState() =>
      _PreviousPrayerEntryScreenState();
}

class _PreviousPrayerEntryScreenState extends State<PreviousPrayerEntryScreen> {
  GlobalKey _key = LabeledGlobalKey("button_icon");
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  Icon icon = Icon(Icons.more_horiz);
  bool _isLoading = false;
  OverlayEntry entry = loading();

  void changeLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
    showOverlay(!value, context);
  }

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
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    var data = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
    int? index = data['index'];
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
                          color: darkBlue,
                          height: height * 0.2,
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
                                child: Text(
                                  "Your Previous Entries",
                                  style: styles.getWhiteHeading(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Swipe through to see your past entries",
                                  style: styles.getNormalWhiteTextStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.5,
                          margin: EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 10,
                          ),
                          child: PageView.builder(
                            controller: PageController(
                              viewportFraction: 0.9,
                              initialPage: index!,
                            ),
                            itemCount: diary.length,
                            itemBuilder: (ctx, i) => PreviousEntryDiary(
                              diary[i],
                              height,
                              width,
                              changeLoading,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            0.1 * width,
                            0,
                            0.1 * width,
                            height * 0.04,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isMenuOpen) closeMenu();
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'BACK',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isMenuOpen) closeMenu();
                                  });
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed(
                                      ScreenNavigationConstant
                                          .NewPrayerEntryScreen);
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
                                      'NEW ENTRY',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: textBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
