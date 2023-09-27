import 'package:digital_soul/Widgets/progress_bar.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/providers/profile.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:provider/provider.dart';
import '../Widgets/CommonWidgets.dart';
import 'package:digital_soul/Widgets/Footer.dart';
import '../Constants/Text_Styles.dart';
import '../Widgets/navigate_buttons.dart';
import '../Constants/Screen_Navigation.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({Key? key}) : super(key: key);

  @override
  _RegisterScreen2State createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  final _formKey = GlobalKey<FormState>();

  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();
  bool _isLoading = false;
  String _email = '';
  String _confirmEmail = '';
  String _password = '';
  String _confirmPassword = '';
  String _firstName = '';
  String _lastName = '';
  String _dob = '';
  String _mrn = '';
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _fill = false;
  bool _isInit = true;
  // String _text =
  //     'Your password should be at least 8 characters long to be secure.';
  bool usernameError = false;
  bool passwordError = false;
  OverlayEntry entry = loading();

  void showOverlay(bool isLoading, BuildContext context) {
    if (isLoading == false) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => Overlay.of(context)!.insert(entry));
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) => entry.remove());
    }
  }

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
    if (_email.isNotEmpty &&
        _confirmEmail.isNotEmpty &&
        _password.isNotEmpty &&
        _confirmPassword.isNotEmpty) {
      setState(() {
        _fill = true;
      });
    } else {
      setState(() {
        _fill = false;
      });
    }
  }

  void submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      // setState(() {
      //   _text =
      //       'Tip: Your password should have at least 8 characters to be secure. Try including special characters like ‘@’ or ‘!’ to make it stronger.';
      // });
      return;
    }
    _formKey.currentState!.save();
    try {
      Provider.of<UserProfile>(context, listen: false).signOut();
      setState(() {
        _isLoading = true;
      });
      showOverlay(false, context);
      var push1 = await Provider.of<UserProfile>(context, listen: false).signup(
        email: _email,
        password: _password,
        firstName: _firstName,
        lastName: _lastName,
        mrn: _mrn,
        dob: _dob,
      );
      setState(() {
        _isLoading = false;
      });
      showOverlay(true, context);
      if (push1) {
        Navigator.of(context)
            .pushNamed(ScreenNavigationConstant.RegisterScreen3);
      }
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
      showOverlay(true, context);
      if (err.toString().contains('The password given is invalid.')) {
        print('invalid password');
        setState(() {
          passwordError = true;
        });
        _formKey.currentState!.validate();
        setState(() {
          passwordError = false;
        });
      }
      if (err.toString().contains('Username already exists in the system.')) {
        print('same user');
        setState(() {
          usernameError = true;
        });
        _formKey.currentState!.validate();
        setState(() {
          usernameError = false;
        });
      }
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
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      _firstName = data['firstName']!;
      _lastName = data['lastName']!;
      _dob = data['dob']!;
      _mrn = data['mrn']!;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    entry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    int _curPage = 2;
    StepProgressView _getStepProgress() {
      return StepProgressView(
        _curPage,
        height,
        width * 0.7,
        width * 0.01,
        (height > 1000 || width > 400) ? height * 0.03 : height * 0.02,
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: backGround,
        body: SafeArea(
          child: Opacity(
            opacity: _isLoading ? 0.3 : 1,
            child: IgnorePointer(
              ignoring: _isLoading,
              child: SizedBox(
                height: height,
                child: Column(
                  children: [
                    Container(
                      color: purpleBG,
                      child: Column(
                        children: [
                          Container(
                            height: (height > 1000 || width > 400)
                                ? height * 0.1
                                : height * 0.09,
                            child: _getStepProgress(),
                          ),
                          registerHeading(
                            // 'Hi ${profile!.userName}',
                            'Hi $_firstName',
                            'Please answer the following',
                            height,
                            width,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                              0.1 * width,
                              0.02 * height,
                              0.1 * width,
                              0,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  heading(styles, 'Email'),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    height: height * 0.1,
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      style:
                                          TextStyle(fontSize: height * 0.015),
                                      decoration: InputDecoration(
                                        helperText: '',
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0,
                                          horizontal: 10.0,
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
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        hintText: 'abc@xyz.com',
                                        hintStyle: styles.getHintTextStyle(),
                                        filled: true,
                                        fillColor: greyBG,
                                      ),
                                      onChanged: (value) {
                                        _email = value;
                                        fillColor();
                                      },
                                      onSaved: (value) {
                                        _email = value!;
                                      },
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(_focusNode2);
                                      },
                                      validator: (String? value) {
                                        if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value!)) {
                                          return 'Incorrect email';
                                        } else if (usernameError) {
                                          return 'The email is already in use';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  heading(styles, 'Confirm Email'),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    height: height * 0.1,
                                    child: TextFormField(
                                      focusNode: _focusNode2,
                                      keyboardType: TextInputType.emailAddress,
                                      style:
                                          TextStyle(fontSize: height * 0.015),
                                      decoration: InputDecoration(
                                        helperText: '',
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0,
                                          horizontal: 10.0,
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
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        hintText: 'abc@xyz.com',
                                        hintStyle: styles.getHintTextStyle(),
                                        filled: true,
                                        fillColor: greyBG,
                                      ),
                                      onChanged: (value) {
                                        _confirmEmail = value;
                                        fillColor();
                                      },
                                      onSaved: (value) {
                                        _confirmEmail = value!;
                                      },
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(_focusNode3);
                                      },
                                      validator: (String? value) {
                                        if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value!)) {
                                          return 'Incorrect email';
                                        } else if (_email != _confirmEmail) {
                                          return 'Email does not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  heading(styles, 'Password'),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    height: height * 0.1,
                                    child: TextFormField(
                                      focusNode: _focusNode3,
                                      style:
                                          TextStyle(fontSize: height * 0.015),
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
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
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
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: _obscureText1,
                                    ),
                                  ),
                                  heading(styles, 'Confirm Password'),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    height: height * 0.1,
                                    child: TextFormField(
                                      focusNode: _focusNode4,
                                      style:
                                          TextStyle(fontSize: height * 0.015),
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
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
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
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: _obscureText2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          NavigateButtons(
                            'PROCEED',
                            'BACK',
                            _fill,
                            height,
                            width,
                            context,
                            submitForm,
                            () {
                              Navigator.of(context).pop();
                            },
                            1,
                          ),
                          Footer(height, width),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.fromLTRB(
                    //     0.1 * width,
                    //     0.03 * height,
                    //     0.1 * width,
                    //     0,
                    //   ),
                    //   child: Text(
                    //     _text,
                    //     style: GoogleFonts.nunito(
                    //       fontSize: height * 0.02,
                    //       color: Colors.grey,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ),
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
