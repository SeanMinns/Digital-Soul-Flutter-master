import 'package:flutter/material.dart';
import 'package:digital_soul/Constants/Colors_App.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Check_Tablet.dart';

class Style {
  double height = 10;

  Style(double height, double width) {
    if (checkTablet(height, width)) {
      this.height = height * 1.25;
    } else {
      this.height = height;
    }
  }

  TextStyle getBlueTextStyle() => GoogleFonts.nunito(
        color: textBlue,
        fontSize: height * 0.02,
      );

  TextStyle getPurpleTextStyle() => GoogleFonts.nunito(
        color: purpleBG,
        fontSize: height * 0.02,
      );

  TextStyle getBlueHeading() => GoogleFonts.nunito(
        color: textBlue,
        fontSize: height * 0.03,
        fontWeight: FontWeight.w600,
      );

  TextStyle getBlackHeading() => GoogleFonts.nunito(
        color: blackHeading,
        fontSize: height * 0.03,
        fontWeight: FontWeight.w600,
      );

  TextStyle getWhiteHeading() => GoogleFonts.nunito(
        color: backGround,
        fontSize: height * 0.03,
        fontWeight: FontWeight.w600,
      );

  TextStyle getNormalHeadingTextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.02,
        color: textBlack,
        fontWeight: FontWeight.w400,
      );
  TextStyle getNormalHeading1TextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.024,
        color: textBlack,
        fontWeight: FontWeight.w400,
      );
  TextStyle getNormalHeading2TextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.025,
        color: textBlack,
        fontWeight: FontWeight.w400,
      );
  TextStyle getSmallHeadingTextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.015,
        color: textBlack,
        fontWeight: FontWeight.w600,
      );

  TextStyle getHintTextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.015,
        color: Colors.black26,
        fontWeight: FontWeight.w400,
      );

  TextStyle getNormalTextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.02,
        color: textBlack,
      );

  TextStyle getNormalWhiteTextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.02,
        color: backGround,
      );

  TextStyle getsmallGreyTextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.02,
        color: textGrey,
      );
  TextStyle getsmallTextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.02,
        color: textDarkgrey,
      );
  TextStyle getsmallGreyTextStyle1() => GoogleFonts.nunito(
        fontSize: height * 0.03,
        color: textGrey,
      );

  TextStyle getDarkGreyHeading() => GoogleFonts.nunito(
        color: textDarkgrey,
        fontSize: height * 0.03,
        fontWeight: FontWeight.w200,
      );

  TextStyle getanswersGreyTextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.02,
        color: greyAnswers,
      );

  TextStyle getanswersWhiteTextStyle() => GoogleFonts.nunito(
        fontSize: height * 0.02,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );

  TextStyle getQuestionTextStyle() => GoogleFonts.nunito(
        color: Color.fromRGBO(80, 83, 89, 1),
        fontSize: height * 0.02,
        fontWeight: FontWeight.w400,
      );

  TextStyle getBoldTextStyle() => GoogleFonts.nunito(
        color: Colors.black,
        fontSize: height * 0.02,
        fontWeight: FontWeight.w400,
      );

  TextStyle getBlueQuestionTextStyle() => GoogleFonts.nunito(
        color: textBlue,
        fontSize: height * 0.024,
        fontWeight: FontWeight.bold,
      );

  TextStyle getDarkGreyTextStyle() => GoogleFonts.nunito(
        color: textDarkgrey,
        fontSize: height * 0.01,
        fontWeight: FontWeight.w200,
      );

  TextStyle getPopUpMainTextStyle(int type) => GoogleFonts.nunito(
        color: Colors.white,
        fontSize: type == 1 ? height * 0.025 : height * 0.03,
        fontWeight: FontWeight.w600,
      );

  TextStyle getPopUpSubTextStyle() => GoogleFonts.nunito(
        color: Colors.white,
        fontSize: height * 0.0175,
        fontWeight: FontWeight.w400,
      );

  TextStyle getPopUpButtonTextStyle() => GoogleFonts.nunito(
        color: textBlack,
        fontSize: height * 0.02,
        fontWeight: FontWeight.w600,
      );
}
