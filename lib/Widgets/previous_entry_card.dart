import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/models/hasNetwork.dart';
import 'package:digital_soul/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_diary.dart';
import '../Constants/Text_Styles.dart';
import 'package:intl/intl.dart';

import 'CommonWidgets.dart';

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

class PreviousEntryDiary extends StatefulWidget {
  final Entry entry;
  final double height;
  final double width;
  final Function changeLoading;

  PreviousEntryDiary(
    this.entry,
    this.height,
    this.width,
    this.changeLoading,
  );

  @override
  _PreviousEntryDiaryState createState() => _PreviousEntryDiaryState();
}

class _PreviousEntryDiaryState extends State<PreviousEntryDiary> {
  String? note;
  OverlayEntry entry = loading();

  void showOverlay(bool isLoading, BuildContext context) {
    if (isLoading == false) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => Overlay.of(context)!.insert(entry));
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) => entry.remove());
    }
  }

  Future<void> openDialogAdd(
    BuildContext context,
    Style styles,
    String note,
  ) {
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: widget.height * 0.6,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Have you noticed any patterns in your prayers?',
                  style: GoogleFonts.nunito(
                    fontSize: widget.height * 0.02,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(80, 83, 89, 1),
                  ),
                ),
                SizedBox(
                  height: widget.height * 0.02,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TextFormField(
                    initialValue: widget.entry.note,
                    maxLines: (widget.height * 0.015).toInt(),
                    decoration: InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      fillColor: Color.fromRGBO(244, 244, 244, 1),
                      hintText: "Write your answer here",
                      hintStyle: styles.getsmallGreyTextStyle(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      note = value;
                    },
                  ),
                ),
                Spacer(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
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
                        onTap: () async {
                          try {
                            widget.changeLoading(true);
                            showOverlay(false, context);
                            Navigator.of(ctx).pop();
                            await Provider.of<Diary>(context, listen: false)
                                .addNote(widget.entry.noteId!, note);
                            widget.changeLoading(false);
                            showOverlay(true, context);
                          } on HttpException catch (_) {
                            widget.changeLoading(false);
                            showOverlay(true, context);
                            await overlayPopup(
                              'assets/server_error.png',
                              'Oops!',
                              'There seems to be an internal server error. Please try again in some time.',
                              'OKAY',
                              context,
                              0.9,
                            );
                          } catch (error) {
                            widget.changeLoading(false);
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
                            }
                          }
                        },
                        child: Text(
                          'DONE',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(44, 141, 164, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    note = "";
    super.initState();
  }

  @override
  void dispose() {
    entry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Style style = new Style(widget.height, widget.width);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Color.fromRGBO(244, 244, 244, 1),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateTime.now().hour > 11
                            ? '${DateFormat("E, LLL d, h:mm").format(widget.entry.date!)}pm'
                            : '${DateFormat("E, LLL d, h:mm").format(widget.entry.date!)}am',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(80, 83, 89, 1),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => widget.entry.note == ''
                            ? openDialogAdd(context, style, note!)
                            : openDialogAdd(context, style, note!),
                        child: Row(
                          children: [
                            Icon(
                              widget.entry.note == ''
                                  ? Icons.add_circle_rounded
                                  : Icons.error_rounded,
                              color: Color.fromRGBO(252, 204, 141, 1),
                            ),
                            Text(
                              widget.entry.note == ''
                                  ? 'add a note'
                                  : 'view note',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(44, 141, 164, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.height * 0.03),
                  RichText(
                    text: TextSpan(
                      text: 'PRAYER TYPE ',
                      style: GoogleFonts.nunito(
                        fontSize: widget.height * 0.015,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.entry.prayerType!.join(', '),
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: widget.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'FEELINGS BEFORE ',
                            style: GoogleFonts.nunito(
                              fontSize: widget.height * 0.015,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: checkTablet(widget.height, widget.width)
                                ? 35
                                : 15,
                            height: checkTablet(widget.height, widget.width)
                                ? 35
                                : 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(emotionAssets[
                                    widget.entry.beforeEmotions! - 1]),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.width * 0.01,
                          ),
                          Container(
                            width: checkTablet(widget.height, widget.width)
                                ? 35
                                : 15,
                            height: checkTablet(widget.height, widget.width)
                                ? 35
                                : 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(stressAssets[
                                    widget.entry.beforeStress! - 1]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'FEELINGS AFTER ',
                            style: GoogleFonts.nunito(
                              fontSize: widget.height * 0.015,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: checkTablet(widget.height, widget.width)
                                ? 35
                                : 15,
                            height: checkTablet(widget.height, widget.width)
                                ? 35
                                : 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(emotionAssets[
                                    widget.entry.afterEmotions! - 1]),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.width * 0.01,
                          ),
                          Container(
                            width: checkTablet(widget.height, widget.width)
                                ? 35
                                : 15,
                            height: checkTablet(widget.height, widget.width)
                                ? 35
                                : 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(stressAssets[
                                    widget.entry.afterStress! - 1]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: widget.height * 0.03),
                  Text(
                    'PRAYER',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(80, 83, 89, 1),
                    ),
                  ),
                  SizedBox(height: widget.height * 0.01),
                  Text(
                    widget.entry.prayer!,
                    style: GoogleFonts.nunito(
                      fontSize: widget.height * 0.02,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(80, 83, 89, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
