import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:digital_soul/providers/sets.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/profile.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/Text_Styles.dart';
import '../Constants/Screen_Navigation.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _obscureText = true;
  final _focusNode = FocusNode();
  bool isLoading = false;
  OverlayEntry entry = loading();

  List selectPage = [
    ScreenNavigationConstant.Set1Screen,
    ScreenNavigationConstant.Set2Screen,
    ScreenNavigationConstant.Set3Screen,
    ScreenNavigationConstant.Set4Screen,
    ScreenNavigationConstant.Set5Screen,
    ScreenNavigationConstant.Set6Screen,
  ];

  void showOverlay(bool isLoading, BuildContext context) {
    if (isLoading == false) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => Overlay.of(context)!.insert(entry));
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) => entry.remove());
    }
  }

  @override
  void dispose() {
    entry.dispose();
    super.dispose();
  }

  void changeObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });
        showOverlay(false, context);
        await Provider.of<UserProfile>(context, listen: false).signOut();
        var push = await Provider.of<UserProfile>(context, listen: false).login(
          email: email,
          password: password,
        );
        var page =
            await Provider.of<Sets>(context, listen: false).setsProgress();
        if (page != 6 && page != -1) {
          setState(() {
            isLoading = false;
          });
          showOverlay(true, context);
          Navigator.of(context).pushNamed(selectPage[page]);
        } else if (page == -1) {
          setState(() {
            isLoading = false;
          });
          showOverlay(true, context);
          Navigator.of(context)
              .pushNamed(ScreenNavigationConstant.RegisterScreen3);
        } else {
          var data = await Provider.of<Lessons>(context, listen: false)
              .setLessonsProgress();
          setState(() {
            isLoading = false;
          });
          showOverlay(true, context);
          if (push) {
            Navigator.of(context).pushNamed(ScreenNavigationConstant.homeScreen,
                arguments: {"progress": data});
          }
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        showOverlay(true, context);
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
        } else if (error == 'Failed since user is not authorized.') {
          final snackBar = SnackBar(
            content: Text('Incorrect email or password'),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          overlayPopup(
            'assets/server_error.png',
            'Oops!',
            'There seems to be an internal server error. Please try again in some time.',
            'OKAY',
            context,
            0.9,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: backGround,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Opacity(
              opacity: isLoading ? 0.3 : 1,
              child: IgnorePointer(
                ignoring: isLoading,
                child: SizedBox(
                  height: height,
                  child: Column(
                    children: [
                      Container(
                        color: purpleBG,
                        width: width,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: height * 0.08,
                                bottom: 0,
                              ),
                              padding: EdgeInsets.only(
                                bottom: height * 0.02,
                              ),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: ' Welcome to \n',
                                  style: styles.getNormalWhiteTextStyle(),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Digital Soul',
                                      style: styles.getWhiteHeading(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 0.06 * height,
                          bottom: 0.08 * height,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to Digital Soul?  ',
                              style: styles.getNormalTextStyle(),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    ScreenNavigationConstant.RegisterScreen1);
                              },
                              child: Text(
                                'Register',
                                style: GoogleFonts.nunito(
                                  color: purpleBG,
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login to get Started',
                              style: styles.getNormalHeadingTextStyle(),
                            ),
                            Container(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 0.10 * width,
                                        right: 0.10 * width,
                                        top: 0.04 * height,
                                      ),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.person_outline_rounded),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          hintText: 'Email',
                                          filled: true,
                                          fillColor: greyBG,
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                              new RegExp(r"\s\b|\b\s"))
                                        ],
                                        validator: (String? value) {
                                          if (value != null && value.isEmpty) {
                                            return 'Enter an email';
                                          } else if (!RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(value!)) {
                                            return 'Incorrect email';
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(context).unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(_focusNode);
                                        },
                                        onSaved: (value) =>
                                            setState(() => email = value!),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 0.10 * width,
                                        right: 0.10 * width,
                                        top: 0.04 * height,
                                      ),
                                      child: TextFormField(
                                        focusNode: _focusNode,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock_outline),
                                          suffixIcon: GestureDetector(
                                            child: Icon(_obscureText
                                                ? Icons.remove_red_eye_outlined
                                                : Icons
                                                    .visibility_off_outlined),
                                            onTap: changeObscure,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          hintText: 'Password',
                                          filled: true,
                                          fillColor: greyBG,
                                        ),
                                        validator: (value) {
                                          if (value!.length < 8) {
                                            return 'Password must be at least 8 characters long';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) =>
                                            setState(() => password = value!),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: _obscureText,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: submitForm,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: 0.30 * width,
                                          right: 0.30 * width,
                                          top: 0.04 * height,
                                        ),
                                        height: 0.06 * height,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                          color: buttonColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'LOG IN',
                                            style: GoogleFonts.nunito(
                                              fontSize:
                                                  checkTablet(height, width)
                                                      ? height * 0.02
                                                      : height * 0.015,
                                              color: textBlack,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 0.05 * height),
                                      child: GestureDetector(
                                        onTap: () {
                                          // print('call register');
                                          Navigator.of(context).pushNamed(
                                              ScreenNavigationConstant
                                                  .ForgotPassword1);
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: styles.getPurpleTextStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
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
        ),
      ),
    );
  }
}
