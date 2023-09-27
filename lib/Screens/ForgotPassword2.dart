import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/Constants/Text_Styles.dart';
import 'package:digital_soul/Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class ForgotPassword2 extends StatefulWidget {
  final String userName;

  ForgotPassword2(this.userName);

  @override
  _ForgotPassword2 createState() => _ForgotPassword2(userName);
}

class _ForgotPassword2 extends State<ForgotPassword2> {
  String otp = "";
  bool isLoading = false;
  String userName;
  bool _fill = false;
  String password = "";
  final _formKey = GlobalKey<FormState>();
  _ForgotPassword2(this.userName);
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();
  String _password = '';
  String _confirmPassword = '';
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool passwordError = false;
  OverlayEntry entry = loading();

  void changeObscure1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void changeObscure2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  Widget heading(Style styles, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: styles.getSmallHeadingTextStyle(),
      ),
    );
  }

  void fillColor() {
    if (_password.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        otp.length == 6) {
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
    Style styles = Style(height, width);
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
                      height: height * 0.1,
                      child: Container(
                        margin: EdgeInsets.only(top: height * 0.035),
                        child: Text(
                          'Reset Password',
                          style: styles.getWhiteHeading(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: height * 0.05,
                        right: width * 0.08,
                        left: width * 0.08,
                      ),
                      child: Text(
                        'A verification code has been sent to your registered email address. Please enter it below.',
                        style: styles.getNormalHeading1TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: height * 0.04,
                        right: width * 0.05,
                        left: width * 0.05,
                      ),
                      child: OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.underline,
                        outlineBorderRadius: 21,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 17),
                        onChanged: (pin) {
                          setState(() {
                            otp = pin;
                          });
                          fillColor();
                        },
                        onCompleted: (pin) {
                          setState(() {
                            otp = pin;
                          });
                          fillColor();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: height * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Didn\'t get the code?  ',
                            style: styles.getNormalTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () async {
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
                                if (res.isPasswordReset != false) {
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
                                showOverlay(true, context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Error occured'),
                                ));
                              }
                            },
                            child: Text(
                              'Resend',
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
                    // Container(
                    //   child: Container(
                    //     margin: EdgeInsets.only(
                    //         top: height * 0.05,
                    //         right: width * 0.08,
                    //         left: width * 0.08),
                    //     child: Text(
                    //       'Verified! You may now enter a new password and continue to login',
                    //       style: styles.getNormalHeading1TextStyle(),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        0.1 * width,
                        0.01 * height,
                        0.1 * width,
                        0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            heading(styles, 'Password'),
                            SizedBox(height: 8),
                            SizedBox(
                              height: height * 0.1,
                              child: TextFormField(
                                focusNode: _focusNode3,
                                style: TextStyle(fontSize: height * 0.015),
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    child: Icon(_obscureText1
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.visibility_off_outlined),
                                    onTap: changeObscure1,
                                  ),
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
                                  hintText: 'At least 8 characters long',
                                  hintStyle: styles.getHintTextStyle(),
                                  filled: true,
                                  fillColor: greyBG,
                                ),
                                onChanged: (value) {
                                  _password = value;
                                  fillColor();
                                },
                                onSaved: (value) {
                                  _password = value!;
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode4);
                                },
                                validator: (String? value) {
                                  if (value!.length < 8) {
                                    return 'Password must be at least 8 characters long';
                                  } else if (passwordError) {
                                    return 'Weak password! Try another?';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscureText1,
                              ),
                            ),
                            heading(styles, 'Confirm Password'),
                            SizedBox(height: 8),
                            SizedBox(
                              height: height * 0.1,
                              child: TextFormField(
                                focusNode: _focusNode4,
                                style: TextStyle(fontSize: height * 0.015),
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    child: Icon(_obscureText2
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.visibility_off_outlined),
                                    onTap: changeObscure2,
                                  ),
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
                                  hintText: 'At least 8 characters long',
                                  hintStyle: styles.getHintTextStyle(),
                                  filled: true,
                                  fillColor: greyBG,
                                ),
                                onChanged: (value) {
                                  _confirmPassword = value;
                                  fillColor();
                                },
                                onSaved: (value) {
                                  _confirmPassword = value!;
                                },
                                onFieldSubmitted: (value) {},
                                validator: (String? value) {
                                  if (_password != _confirmPassword) {
                                    return 'Password does not match';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscureText2,
                              ),
                            ),
                          ],
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
                          if (_fill && isValid) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              showOverlay(false, context);
                              await Amplify.Auth.confirmPassword(
                                username: userName,
                                newPassword: _password,
                                confirmationCode: otp,
                              ).whenComplete(() {
                                setState(() {
                                  isLoading = false;
                                });
                                showOverlay(true, context);
                              });
                              await overlayPopup(
                                'assets/password_reset.png',
                                'New Password Set!',
                                'You can proceed to the login page and continue to access DigitalSoul',
                                'Let’s Login',
                                context,
                                0.95,
                              );
                              Navigator.of(context).pushNamed(
                                  ScreenNavigationConstant.loginScreen);
                              /*ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Wrong username or user doesnt exist'),
                                        ),
                                      );*/
                            } on AmplifyException catch (e) {
                              print(e.message);
                              setState(() {
                                isLoading = false;
                              });
                              showOverlay(true, context);
                              if (e.message ==
                                  'Confirmation code entered is not correct.') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('OTP entered is incorrect'),
                                  ),
                                );
                              } else if (e.message
                                  .contains('The password given is invalid.')) {
                                print('invalid password');
                                setState(() {
                                  passwordError = true;
                                });
                                _formKey.currentState!.validate();
                                setState(() {
                                  passwordError = false;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error occured'),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              'RESET',
                              style: styles.getPopUpButtonTextStyle(),
                              textAlign: TextAlign.center,
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
