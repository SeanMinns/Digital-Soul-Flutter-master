import 'package:digital_soul/Widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/CommonWidgets.dart';
import '../Constants/Text_Styles.dart';
import '../Widgets/Footer.dart';
import '../Constants/Screen_Navigation.dart';
import '../Widgets/navigate_buttons.dart';
import 'package:intl/intl.dart';

class RegisterScreen1 extends StatefulWidget {
  const RegisterScreen1({Key? key}) : super(key: key);

  @override
  _RegisterScreen1State createState() => _RegisterScreen1State();
}

class _RegisterScreen1State extends State<RegisterScreen1> {
  final _formKey = GlobalKey<FormState>();

  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();
  final _focusNode5 = FocusNode();

  String _firstName = '';
  String _lastName = '';
  String _dob = '';
  String _mrn = '';
  bool _fill = false;

  Future<void> displayMrn(double height, double width) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/mrn.png",
              fit: BoxFit.cover,
              height: height * 0.4,
              width: width * 0.5,
            ),
          ),
        );
      },
    );
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
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _dob.isNotEmpty &&
        _mrn.isNotEmpty) {
      setState(() {
        _fill = true;
      });
    } else {
      setState(() {
        _fill = false;
      });
    }
  }

  void submitForm() {
    final isValid = _formKey.currentState!.validate();
    print('passed1');
    if (!isValid) {
      return;
    }
    print('passed');
    _formKey.currentState!.save();
    Navigator.of(context)
        .pushNamed(ScreenNavigationConstant.RegisterScreen2, arguments: {
      "firstName": _firstName,
      "lastName": _lastName,
      "dob": _dob,
      "mrn": _mrn,
    });
  }

  void _presentDatePicker() {
    var prevYear;
    prevYear = DateTime.now().year - 100;
    var day = DateTime.now().day;
    var month = DateTime.now().month;
    var date = DateTime.now();
    print(date);
    showDatePicker(
      context: context,
      initialDate: _dob == ''
          ? date
          : DateTime(int.parse(_dob.split('/')[2]),
              int.parse(_dob.split('/')[0]), int.parse(_dob.split('/')[1])),
      firstDate: DateTime(prevYear, month, day),
      lastDate: date,
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      var formatter = new DateFormat('MM/dd/yyyy');
      var chosenDate = formatter.format(pickedDate);
      setState(() {
        _dob = chosenDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Style styles = new Style(height, width);
    int _curPage = 1;
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
                        'Let\'s Get You Registered',
                        'All fields are mandatory to proceed.',
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
                              heading(styles, 'First Name'),
                              SizedBox(height: height * 0.01),
                              SizedBox(
                                height: height * 0.1,
                                child: new TextFormField(
                                  style: TextStyle(fontSize: height * 0.015),
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
                                    hintText: 'Enter Here',
                                    hintStyle: styles.getHintTextStyle(),
                                    filled: true,
                                    fillColor: greyBG,
                                  ),
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode2);
                                  },
                                  onSaved: (value) {
                                    _firstName = value!;
                                  },
                                  onChanged: (value) {
                                    _firstName = value;
                                    fillColor();
                                  },
                                  validator: (String? value) {},
                                ),
                              ),
                              heading(styles, 'Last Name'),
                              SizedBox(height: height * 0.01),
                              SizedBox(
                                height: height * 0.1,
                                child: new TextFormField(
                                  focusNode: _focusNode2,
                                  style: TextStyle(fontSize: height * 0.015),
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
                                    hintText: 'Enter Here',
                                    hintStyle: styles.getHintTextStyle(),
                                    filled: true,
                                    fillColor: greyBG,
                                  ),
                                  onChanged: (value) {
                                    _lastName = value;
                                    fillColor();
                                  },
                                  onSaved: (value) {
                                    _lastName = value!;
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode3);
                                  },
                                  validator: (String? value) {},
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        heading(styles, 'Date of Birth'),
                                        SizedBox(height: height * 0.01),
                                        SizedBox(
                                          height: height * 0.1,
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: _presentDatePicker,
                                            child: TextField(
                                              enabled: false,
                                              focusNode: _focusNode3,
                                              style: TextStyle(
                                                  fontSize: height * 0.015),
                                              decoration: InputDecoration(
                                                helperText: '',
                                                enabled: false,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 10.0,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                hintText: _dob == ''
                                                    ? 'MM/DD/YYYY'
                                                    : _dob,
                                                hintStyle: _dob == ''
                                                    ? styles.getHintTextStyle()
                                                    : GoogleFonts.nunito(
                                                        fontSize:
                                                            height * 0.015,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                filled: true,
                                                fillColor: greyBG,
                                              ),
                                              // keyboardType:
                                              //     TextInputType.number,
                                              // inputFormatters: [
                                              //   FilteringTextInputFormatter
                                              //       .digitsOnly,
                                              //   new LengthLimitingTextInputFormatter(
                                              //       8),
                                              //   new CardMonthInputFormatter(),
                                              // ],
                                              // onChanged: (value) {
                                              //   _dob = value;
                                              //   fillColor();
                                              // },
                                              // onSaved: (value) {
                                              //   _dob = value!;
                                              // },
                                              // onFieldSubmitted: (value) {
                                              //   FocusScope.of(context)
                                              //       .requestFocus(_focusNode4);
                                              // },
                                              // validator: (String? value) {
                                              //   if (!RegExp(
                                              //           r'^(1[0-2]|0[1-9])/(3[01]|[12][0-9]|0[1-9])/[0-9]{4}$')
                                              //       .hasMatch(value!)) {
                                              //     return 'Incorrect DOB';
                                              //   } else {
                                              //     return null;
                                              //   }
                                              // },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width * 0.03),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                heading(styles,
                                                    'Medical Record Number'),
                                                SizedBox(height: height * 0.01),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      displayMrn(height, width),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    decoration:
                                                        new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: buttonColor,
                                                    ),
                                                    child: Text(
                                                      '?',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.1,
                                          child: new TextFormField(
                                            focusNode: _focusNode4,
                                            style: TextStyle(
                                                fontSize: height * 0.015),
                                            decoration: InputDecoration(
                                              helperText: '',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal: 10.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              hintText:
                                                  'Enter -999 if you don\'t have',
                                              hintStyle:
                                                  styles.getHintTextStyle(),
                                              filled: true,
                                              fillColor: greyBG,
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              // FilteringTextInputFormatter
                                              //     .digitsOnly,
                                              // FilteringTextInputFormatter.allow(
                                              //     RegExp(r'[\d+\-]')),
                                            ],
                                            onChanged: (value) {
                                              _mrn = value;
                                              fillColor();
                                            },
                                            onSaved: (value) {
                                              _mrn = value!;
                                            },
                                            onFieldSubmitted: (value) {
                                              FocusScope.of(context).unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(_focusNode5);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.16,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class CardMonthInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     var text = newValue.text;

//     if (newValue.selection.baseOffset == 0) {
//       return newValue;
//     }

//     var buffer = new StringBuffer();
//     for (int i = 0; i < text.length; i++) {
//       buffer.write(text[i]);
//       var nonZeroIndex = i + 1;
//       if (nonZeroIndex % 2 == 0 &&
//           nonZeroIndex != 6 &&
//           nonZeroIndex != text.length) {
//         buffer.write('/');
//       }
//     }

//     var string = buffer.toString();
//     return newValue.copyWith(
//         text: string,
//         selection: new TextSelection.collapsed(offset: string.length));
//   }
// }
