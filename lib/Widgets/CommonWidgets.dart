import 'package:digital_soul/Constants/Check_Tablet.dart';
import 'package:digital_soul/Constants/Screen_Navigation.dart';
import 'package:digital_soul/providers/lessons.dart';
import 'package:digital_soul/providers/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Constants/Colors_App.dart';
import '../Constants/Text_Styles.dart';

List<String> suicidalWords = [
  "Suicide",
  "I want to die",
  "don\'t want to be alive anymore",
  "want die",
  "kill myself",
  "afraid of death",
  "attempted suicide",
  "suicide attempt",
  "hanging",
  "gun",
  "rope",
  "noose",
  "knife",
  "end it all",
  "end my life",
  "stop living",
];

List<String> mcqQuestions1Register3 = [
  'Depression',
  'Anxiety',
  'Trauma',
  'Addiction',
  'Bipolar',
  'Psychosis',
  'OCD',
  'Other',
];

List<String> mcqQuestions2Register3 = [
  'My symptoms sometimes take on religious themes',
  'Spirituality/religion is a positive resource for me (e.g., provides hope)',
  'Spirituality/religion is a source of strain and emotional pain for me (i.e., spiritual struggles)',
  'Spirituality/religion is not be directly relevant to my mental health',
];

List<String> emotionText = [
  'Extremely Happy',
  'Very Happy',
  'Somewhat Happy',
  'Somewhat Sad',
  'Sad',
  'Very Sad'
];
List<String> stressText = [
  'Extremely Calm',
  'Very Calm',
  'Somewhat Calm',
  'Somewhat Stressed',
  'Stressed',
  'Very Stressed'
];

List<String> mcqQuestionsDiary = [
  "To express gratitude or praise",
  "To request help for yourself or others",
  "To converse with your Higher power",
  "To ask for forgiveness",
  "To cope with distress",
  "To be given strength"
];

List<String> mcqWordQuestionsDiary = [
  'Gratitude',
  'Help',
  'Converse',
  'Forgiveness',
  'Coping',
  'Strength'
];

List<String> mcqQuestionsLesson1 = [
  'We are never alone',
  'Nothing is impossible',
  'Life is a test',
  'We can only control the process, not the outcome',
  'Everything happens for a reason',
  'Nothing is permanent',
];

List<String> dropdownQuestionsLesson2 = [
  "Prayer",
  "Meditate on a Coping Statement",
  "Seek Religious Support",
  "Sacred Texts",
  "Forgiveness of Others",
  "Good Deeds",
  "Religious Framing"
];
Map<String, List<String>> mapQuestionLesson2 = {
  "Prayer": ['praying'],
  "Meditate on a Coping Statement": ['meditating on a coping statement'],
  "Seek Religious Support": ['seeking religious support'],
  "Sacred Texts": ['using sacred texts'],
  "Forgiveness of Others": ['forgiveness'],
  "Good Deeds": ['doing good deeds'],
  "Religious Framing": ['religious framing']
};
List<String> iconMcqQuestions = [
  "Happy",
  "Sad",
  "Angry",
  "Guilty",
  "Stressed",
  "Grateful",
];

List<String> mcqIcons = [
  "assets/happy_icon.png",
  "assets/sad_icon.png",
  "assets/angry_icon.png",
  "assets/guilty_icon.png",
  "assets/stressed_icon.png",
  "assets/grateful_icon.png",
];

List<String> mcqQuestionsLesson3 = [
  'Intrapersonal Spiritual Struggles',
  'Interpersonal Spiritual Struggles',
  'Divine Spiritual Struggles',
];

List<String> mcqQuestionsWithDropdown1Lesson3 = [
  'Excessive religious guilt – Feeling overly blameworthy for one’s sins',
  'Moral injury – Feeling conflicted: Did I break my moral code?',
  'Religious self-loathing – Hating oneself for religious reasons',
  'Religious failure – Feeling incapable of reaching religious standards',
  'Spiritual constraint – Feeling that one’s physical needs are a barrier to spirituality',
  'Existential crises – Questioning our purpose in life: Why am I here?',
];

List<String> mcqQuestionsWithDropdown2Lesson3 = [
  'Lack of religious support – Feeling unsupported by clergy or faith community',
  'Faith community rejection – Feeling excluded or ignored by one’s religious community',
  'Religious disagreement – Questioning or feeling disappointed with religious leadership or teachings',
  'Creating religious boundaries – Avoiding or ignoring clergy or faith community members',
  'Counterfeit religiosity – Feeling that others are religiously inauthentic',
  'Religious betrayal/harm – Feeling deceived, wronged, or hurt by religious individuals',
];

List<String> mcqQuestionsWithDropdown3Lesson3 = [
  'Passive religious deferral – Expecting God to solve one’s problems without exerting any personal effort',
  'Reappraisals of God – Feeling that God has limits and cannot provide assistance',
  'Demonic appraisals – Believing that the devil is responsible for one’s situation',
  'Punishment appraisals – Feeling punished or cursed by the Divine',
  'Spiritual discontent – Feeling abandoned or unloved by God',
  'Anger towards God – Feeling deceived, wronged or hurt by the Divine',
];

List<String> dropDownQuestionsLesson3 = [
  'Clergy',
  'Family',
  'Friends',
  'Other people in your faith communities',
  'Your treatment providers',
];

List<String> mcqQuestionsWithOtherLesson5 = [
  'Myself',
  'My mental disorder',
  'My friends',
  'My family',
  'God',
  'Other',
];

List<String> mcqQuestionsLesson5 = [
  'Recalling the hurt',
  'Able to empathize',
  'Ready to decide to forgive',
  'Committed to forgiving',
  'Establishing a new normal',
];

Map<String, List<String>> mapQuestionLesson5 = {
  "Recalling the hurt": ["recalling the hurt", "being able to empathize"],
  "Able to empathize": ["able to empathize", "being ready to forgive"],
  "Ready to decide to forgive": ["ready to forgive", "committing to forgive"],
  "Committed to forgiving": [
    "committed to forgiving",
    "establishing a new normal"
  ],
  "Establishing a new normal": [
    "establishing a new normal",
    "further establishing a new normal"
  ],
};

List<String> mcqQuestions1Lesson4 = [
  'Gratitude or praise',
  'Help for yourself or others',
  'Connect with a Higher power',
  'Forgiveness',
  'To ask for strength',
  'To cope with distress',
  'None of these',
];

List<String> mcqQuestions2Lesson4 = [
  'Scripted from a text',
  'Scheduled',
  'Spontaneous',
  'Community',
  'Comtemplatively(e.g., meditation)',
  'None of these',
];

List<String> mcqQuestions3Lesson4 = [
  'Joy',
  'Sadness',
  'Anxiety',
  'Pain',
];

List<String> ageQuestion = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
  '32',
  '33',
  '34',
  '35',
  '36',
  '37',
  '38',
  '39',
  '40',
  '41',
  '42',
  '43',
  '44',
  '45',
  '46',
  '47',
  '48',
  '49',
  '50',
  '51',
  '52',
  '53',
  '54',
  '55',
  '56',
  '57',
  '58',
  '59',
  '60',
  '61',
  '62',
  '63',
  '64',
  '65',
  '66',
  '67',
  '68',
  '69',
  '70',
  '71',
  '72',
  '73',
  '74',
  '75',
  '76',
  '77',
  '78',
  '79',
  '80',
  '81',
  '82',
  '83',
  '84',
  '85',
  '86',
  '87',
  '88',
  '89',
  '90',
  '91',
  '92',
  '93',
  '94',
  '95',
  '96',
  '97',
  '98',
  '99',
  '100'
];

List<String> mcqQuestions1Set1 = [
  'Male',
  'Female',
  'Trans Male/Trans Man',
  'Trans Female/Trans Woman',
  'Genderqueer/Gender NonConforming',
  'Other'
];

List<String> mcqQuestions2Set1 = [
  "Male",
  "Female",
];

List<String> mcqQuestions3Set1 = [
  'Heterosexual or Straight',
  'Gay',
  'Lesbian',
  'Bisexual',
  'Not listed above'
];

List<String> mcqQuestions4Set1 = [
  "White",
  "Hispanic, Latino or Spanish origin ",
  "Black or African American",
  "Asian",
  "Native American",
  "Middle Eastern or North African",
  'Other'
];

List<String> dropDownSet3 = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
  '32',
  '33',
  '34',
  '35',
  '36',
  '37',
  '38',
  '39',
  '40',
  '41',
  '42',
  '43',
  '44',
  '45',
  '46',
  '47',
  '48',
  '49',
  '50',
  '51',
  '52',
  '53',
  '54',
  '55',
  '56',
  '57',
  '58',
  '59',
  '60',
  '61',
  '62',
  '63',
  '64',
  '65',
  '66',
  '67',
  '68',
  '69',
  '70',
  '71',
  '72',
  '73',
  '74',
  '75',
  '76',
  '77',
  '78',
  '79',
  '80',
  '81',
  '82',
  '83',
  '84',
  '85',
  '86',
  '87',
  '88',
  '89',
  '90',
  '91',
  '92',
  '93',
  '94',
  '95',
  '96',
  '97',
  '98',
  '99',
  '100',
  '101',
  '102',
  '103',
  '104',
  '105',
  '106',
  '107',
  '108',
  '109',
  '110',
  '111',
  '112',
  '113',
  '114',
  '115',
  '116',
  '117',
  '118',
  '119',
  '120',
  '121',
  '122',
  '123',
  '124',
  '125',
  '126',
  '127',
  '128',
  '129',
  '130',
  '131',
  '132',
  '133',
  '134',
  '135',
  '136',
  '137',
  '138',
  '139',
  '140',
  '141',
  '142',
  '143',
  '144',
  '145',
  '146',
  '147',
  '148',
  '149',
  '150',
  '151',
  '152',
  '153',
  '154',
  '155',
  '156',
  '157',
  '158',
  '159',
  '160',
  '161',
  '162',
  '163',
  '164',
  '165',
  '166',
  '167',
  '168',
  '169',
  '170',
  '171',
  '172',
  '173',
  '174',
  '175',
  '176',
  '177',
  '178',
  '179',
  '180',
  '181',
  '182',
  '183',
  '184',
  '185',
  '186',
  '187',
  '188',
  '189',
  '190',
  '191',
  '192',
  '193',
  '194',
  '195',
  '196',
  '197',
  '198',
  '199',
  '200',
  '201',
  '202',
  '203',
  '204',
  '205',
  '206',
  '207',
  '208',
  '209',
  '210',
  '211',
  '212',
  '213',
  '214',
  '215',
  '216',
  '217',
  '218',
  '219',
  '220',
  '221',
  '222',
  '223',
  '224',
  '225',
  '226',
  '227',
  '228',
  '229',
  '230',
  '231',
  '232',
  '233',
  '234',
  '235',
  '236',
  '237',
  '238',
  '239',
  '240',
  '241',
  '242',
  '243',
  '244',
  '245',
  '246',
  '247',
  '248',
  '249',
  '250',
  '251',
  '252',
  '253',
  '254',
  '255',
  '256',
  '257',
  '258',
  '259',
  '260',
  '261',
  '262',
  '263',
  '264',
  '265',
  '266',
  '267',
  '268',
  '269',
  '270',
  '271',
  '272',
  '273',
  '274',
  '275',
  '276',
  '277',
  '278',
  '279',
  '280',
  '281',
  '282',
  '283',
  '284',
  '285',
  '286',
  '287',
  '288',
  '289',
  '290',
  '291',
  '292',
  '293',
  '294',
  '295',
  '296',
  '297',
  '298',
  '299',
  '300',
  '301',
  '302',
  '303',
  '304',
  '305',
  '306',
  '307',
  '308',
  '309',
  '310',
  '311',
  '312',
  '313',
  '314',
  '315',
  '316',
  '317',
  '318',
  '319',
  '320',
  '321',
  '322',
  '323',
  '324',
  '325',
  '326',
  '327',
  '328',
  '329',
  '330',
  '331',
  '332',
  '333',
  '334',
  '335',
  '336',
  '337',
  '338',
  '339',
  '340',
  '341',
  '342',
  '343',
  '344',
  '345',
  '346',
  '347',
  '348',
  '349',
  '350',
  '351',
  '352',
  '353',
  '354',
  '355',
  '356',
  '357',
  '358',
  '359',
  '360',
  '361',
  '362',
  '363',
  '364',
  '365'
];
List<String> set2SliderText = [
  'NOT AT ALL',
  'SOMEWHAT',
  'QUITE A BIT',
  'A GREAT DEAL',
];
List<String> set2SliderImages = [
  'assets/flower1.png',
  'assets/flower2.png',
  'assets/flower3.png',
  'assets/flower4.png'
];
List<String> tutorial = [
  'assets/rainbow1.png',
  'assets/rainbow2.png',
  'assets/rainbow3.png',
  'assets/rainbow4.png',
];
List<String> set4SliderText = [
  'NOT AT ALL',
  'SLIGHTLY',
  'FAIRLY',
  'MODERATELY',
  'VERY',
];
List<String> set4SliderImages = [
  'assets/glass1.png',
  'assets/glass2.png',
  'assets/glass3.png',
  'assets/glass4.png',
  'assets/glass5.png',
];
List<String> set4SliderText2 = [
  'RARELY OR NEVER',
  'A FEW TIMES PER MONTH',
  'ONCE PER WEEK',
  'A FEW TIMES PER WEEK',
  'ONCE PER DAY',
  'MORE THAN ONCE PER DAY'
];
List<String> set4SliderText3 = [
  'NEVER',
  'ONCE PER YEAR OR LESS',
  'A FEW TIMES PER YEAR',
  'A FEW TIMES PER MONTH',
  'ONCE PER WEEK',
  'MORE THAN ONCE PER WEEK'
];
List<String> set4SliderImages2 = [
  'assets/icecream1.png',
  'assets/icecream2.png',
  'assets/icecream3.png',
  'assets/icecream4.png',
  'assets/icecream5.png',
  'assets/icecream6.png'
];
List<String> mcqQuestions1Set4 = [
  'Buddhist',
  "Catholic",
  "Jewish",
  "Muslim",
  "Protestant Christian",
  "Other",
];
List<String> set5SliderText = [
  'NOT AT ALL',
  'SEVERAL DAYS',
  'MORE THAN HALF THE DAYS',
  'NEARLY EVERY DAY',
];
List<String> set5SliderImages = [
  'assets/Sunny.png',
  'assets/Sunny1.png',
  'assets/Sunny2.png',
  'assets/Sunny3.png'
];
List<String> set6SliderText = [
  'NOT AT ALL',
  'SEVERAL DAYS',
  'MORE THAN HALF THE DAYS',
  'NEARLY EVERY DAY',
];

List<String> set6SliderImages = [
  'assets/plant1.png',
  'assets/plant2.png',
  'assets/plant3.png',
  'assets/plant4.png',
];

List buttonQuestionColors = [
  Color(0xff62E1A2),
  Color(0xff90C79A),
  Color(0xffC8A590),
  Color(0xffFB8787)
];
List buttonQuestionColors1 = [
  Color(0xff60E2A3),
  Color(0xff8DC3C1),
  Color(0xffB3AADB),
  Color(0xffE587FD)
];
List buttonQuestionAnswers = [
  'Not difficult at all',
  'Somewhat difficult',
  'Very difficult',
  'Extremely difficult'
];

Widget registerHeading(
  String heading,
  String text,
  double height,
  double width,
) {
  Style styles = new Style(height, width);
  return Container(
    margin: EdgeInsets.fromLTRB(
      0.1 * width,
      height * 0.02,
      0.1 * width,
      height * 0.03,
    ),
    width: width,
    child: Column(
      children: [
        Text(
          heading,
          style: styles.getWhiteHeading(),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: height * 0.005),
        Text(
          text,
          style: styles.getNormalWhiteTextStyle(),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Future<void> overlayPopup(
  String image,
  String mainText,
  String subText,
  String buttonName,
  BuildContext context,
  double multiplier,
) {
  double height =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  double width = MediaQuery.of(context).size.width;
  Style styles = new Style(height, width);
  return showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: purpleBG,
            height: checkTablet(height, width)
                ? height * 0.65 * multiplier
                : height * 0.58 * multiplier,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Image.asset(
                  image,
                  height: height * 0.23,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    mainText,
                    style: styles.getPopUpMainTextStyle(1),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    subText,
                    textAlign: TextAlign.center,
                    style: styles.getPopUpSubTextStyle(),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
                        buttonName,
                        style: styles.getPopUpButtonTextStyle(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> overlayPopup2(
  String image,
  String mainText,
  String subText,
  String buttonName,
  Function buttonFunction,
  BuildContext context,
) {
  double height =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  double width = MediaQuery.of(context).size.width;
  Style styles = new Style(height, width);
  return showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: purpleBG,
            height: height * 0.6,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                Image.asset(
                  image,
                  height: height * 0.25,
                ),
                //
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    mainText,
                    style: styles.getPopUpMainTextStyle(1),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    subText,
                    textAlign: TextAlign.center,
                    style: styles.getPopUpSubTextStyle(),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(ctx).pop();
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
                              "CANCEL",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(252, 204, 141, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          buttonFunction();
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
                              buttonName,
                              style: styles.getPopUpButtonTextStyle(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> overlayPopup3(
  String image,
  String mainText,
  String subText,
  String buttonName1,
  String buttonName2,
  Function buttonFunction1,
  Function buttonFunction2,
  BuildContext context,
) {
  double height =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  double width = MediaQuery.of(context).size.width;
  Style styles = new Style(height, width);
  return showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: purpleBG,
            height: height * 0.6,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                Image.asset(
                  image,
                  height: height * 0.25,
                ),
                //
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    mainText,
                    style: styles.getPopUpMainTextStyle(1),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    subText,
                    textAlign: TextAlign.center,
                    style: styles.getPopUpSubTextStyle(),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          buttonFunction2();
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
                              buttonName2,
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(252, 204, 141, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          buttonFunction1();
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
                              buttonName1,
                              style: styles.getPopUpButtonTextStyle(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

OverlayEntry moreOverlay(Offset? buttonPosition, Size? buttonSize,
    bool isLesson, int lessonNo, VoidCallback callback, BuildContext context) {
  void buttonFunction(UserProfile userProfile, Lessons lessons) {
    Navigator.of(context).pop();
    Navigator.of(context).popAndPushNamed(ScreenNavigationConstant.loginScreen);
    Future.delayed(Duration(seconds: 2), () {
      userProfile.signOut();
      lessons.clearLessons();
    });
  }

  UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);
  Lessons lessons = Provider.of<Lessons>(context, listen: false);
  return OverlayEntry(
    builder: (context) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      Style styles = new Style(height, width);
      return Positioned(
        top: buttonPosition!.dy + buttonSize!.height,
        right: buttonPosition.dx + width * 0.02,
        width: width * 0.4,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 1.0,
                  width: width,
                  color: Colors.black26,
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    height: height * 0.05,
                    width: width * 0.4,
                    padding: EdgeInsets.only(left: width * 0.05),
                    alignment: Alignment.centerLeft,
                    child:
                        Text('PICK A LESSON', style: styles.getBlueTextStyle()),
                  ),
                  onTap: () {
                    callback();
                    Navigator.pushNamed(
                        context, ScreenNavigationConstant.PickLessonScreen);
                  },
                ),
                Container(
                  height: 1.0,
                  width: width,
                  color: Colors.black26,
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    height: height * 0.05,
                    width: width * 0.4,
                    padding: EdgeInsets.only(left: width * 0.05),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PRAYER DIARY',
                      style: styles.getBlueTextStyle(),
                    ),
                  ),
                  onTap: () {
                    callback();
                    Navigator.pushNamed(
                        context, ScreenNavigationConstant.PrayerDiaryScreen);
                  },
                ),
                (isLesson)
                    ? Container(
                        height: 1.0,
                        width: width,
                        color: Colors.black26,
                      )
                    : Container(),
                (isLesson)
                    ? GestureDetector(
                        child: Container(
                          color: Colors.white,
                          height: height * 0.05,
                          width: width * 0.4,
                          padding: EdgeInsets.only(left: width * 0.05),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Provider.of<Lessons>(context, listen: true)
                                    .captions[lessonNo]
                                ? 'Caption : On'.toUpperCase()
                                : 'Caption : Off'.toUpperCase(),
                            style: styles.getBlueTextStyle(),
                          ),
                        ),
                        onTap: () {
                          callback();
                          //code for captions below
                          lessons.changeCaptions(
                              lessonNo, !lessons.captions[lessonNo]);
                        })
                    : Container(),
                Container(
                  height: 1.0,
                  width: width,
                  color: Colors.black26,
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    height: height * 0.05,
                    width: width * 0.4,
                    padding: EdgeInsets.only(left: width * 0.05),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Logout',
                      style: styles.getsmallGreyTextStyle(),
                    ),
                  ),
                  onTap: () {
                    callback();
                    overlayPopup2(
                      'assets/Logout.png',
                      'Are You Sure?',
                      'We hope you return soon enough to try out the lessons or to make a new diary entry.',
                      'LOGOUT',
                      () => buttonFunction(userProfile, lessons),
                      context,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

OverlayEntry loading() {
  return OverlayEntry(
    builder: (context) {
      return Center(
        child: CircleAvatar(
          foregroundColor: lesson3ProgresLeft,
          backgroundColor: lesson3ProgresLeft,
          radius: isTab ? 150 : 75,
          child: Image.asset(
            'assets/Loader.gif',
            filterQuality: FilterQuality.high,
          ),
        ),
      );
    },
  );
}

List thumbBlue = [
  'assets/circle1_glow.png',
  'assets/circle1.png',
];
List thumbGreen = [
  'assets/circle3_glow.png',
  'assets/circle3.png',
];
List thumbBrown = [
  'assets/circle2_glow.png',
  'assets/circle2.png',
];
