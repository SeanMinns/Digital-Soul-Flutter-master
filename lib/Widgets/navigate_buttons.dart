import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/Colors_App.dart';

class NavigateButtons extends StatelessWidget {
  final String nextName;
  final String backName;
  final bool isFilled;
  final double height;
  final double width;
  final BuildContext context;
  final Function next;
  final Function back;
  final int type;

  NavigateButtons(
    this.nextName,
    this.backName,
    this.isFilled,
    this.height,
    this.width,
    this.context,
    this.next,
    this.back,
    this.type,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        0.1 * width,
        0,
        0.1 * width,
        height * 0.04,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          type == 0
              ? Container()
              : InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  onTap: () {
                    back();
                  },
                  child: Ink(
                    height: 0.06 * height,
                    width: 0.2 * width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        backName,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              onTap: () {
                if (isFilled) {
                  next();
                }
              },
              child: Ink(
                height: 0.06 * height,
                width: 0.25 * width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  color: isFilled ? buttonColor : disabledButtonColor,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/arrow.png',
                    color: textBlack,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
