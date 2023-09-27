import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Screens/ForgotPassword2.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:otp_text_field/otp_field.dart';
// import 'package:otp_text_field/style.dart';

class ForgotPassword1 extends StatefulWidget {
  @override
  _ForgotPassword1 createState() => _ForgotPassword1();
}

class _ForgotPassword1 extends State<ForgotPassword1> {
  String userName = "";
  bool _fill = false;
  final _formKey = GlobalKey<FormState>();
  final _focusNode2 = FocusNode();
  bool isLoading = false;
  String buttonName = "NEXT";
  OverlayEntry entry = loading();

  // bool flag = false;
  void fillColor() {
    if (userName.length > 0) {
      setState(() {
        _fill = true;
      });
    } else {
      setState(() {
        _fill = false;
      });
    }
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
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style style = Style(height, width);
    return Scaffold(
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
                            // margin: EdgeInsets.only(
                            //   top: height * 0.03,
                            //   bottom: 0,
                            // ),
                            padding: EdgeInsets.only(
                              top: height * 0.03,
                              bottom: height * 0.03,
                            ),
                            child: Text(
                              'Forgot Password?',
                              textAlign: TextAlign.center,
                              style: style.getWhiteHeading(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: height * 0.04,
                        bottom: height * 0.02,
                      ),
                      child: Text(
                        'Please Enter Your Email',
                        // style: flag
                        //     ? style.getsmallGreyTextStyle()
                        //     : style.getNormalTextStyle(),
                        style: style.getNormalTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: height * 0.01,
                        left: width * 0.1,
                        right: width * 0.1,
                      ),
                      child: Form(
                        key: _formKey,
                        child: SizedBox(
                          height: height * 0.1,
                          child: TextFormField(
                            style: TextStyle(fontSize: height * 0.015),
                            decoration: InputDecoration(
                              helperText: '',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 10.0,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              hintText: 'Enter email',
                              hintStyle: style.getHintTextStyle(),
                              filled: true,
                              fillColor: greyBG,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  new RegExp(r"\s\b|\b\s"))
                            ],
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_focusNode2);
                            },
                            onSaved: (value) {
                              userName = value!;
                            },
                            onChanged: (value) {
                              userName = value;
                              fillColor();
                            },
                            validator: (String? value) {
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)) {
                                return 'Incorrect email';
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      width: width * 0.4,
                      decoration: BoxDecoration(
                        color: _fill ? buttonColor : disabledButtonColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: InkWell(
                        highlightColor: Colors.amber,
                        onTap: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (isValid) {
                            setState(() {
                              isLoading = true;
                            });
                            showOverlay(false, context);
                            try {
                              ResetPasswordResult res =
                                  await Amplify.Auth.resetPassword(
                                username: userName,
                              );
                              setState(() {
                                isLoading = false;
                              });
                              showOverlay(true, context);
                              if (res.isPasswordReset == false) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPassword2(userName),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Wrong email or user doesnt exist'),
                                  ),
                                );
                              }
                            } on AmplifyException catch (e) {
                              print(e);
                              setState(() {
                                isLoading = false;
                              });
                              showOverlay(false, context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Error occured'),
                              ));
                            }
                          }
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              buttonName,
                              style: style.getPopUpButtonTextStyle(),
                            ),
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
        ),
      ),
    );
  }
}
