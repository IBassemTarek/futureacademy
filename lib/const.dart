import 'package:flutter/material.dart';

const Color kBackgroundColor = Color(0xFFF2F2F2);

const Color kAccentColor = Color(0xFFFAE3D9);
const Color kAccentColor2 = Color(0xFFF5725E);
const Color kAccentColor3 = Color(0xFFFFB6B9);
const Color kAccentColor4 = Color(0xFFFFDC8B);

const Color kTextColor = Color(0xFF222222);
const Color kGradColor1 = Color(0xFF671D89);
const Color kGradColor2 = Color(0xFF101856);
const Color kShadowColor = Color(0x4F9E9E9E);
const Color kHintColor = Color(0x99000000);

BoxDecoration roundedContainer({required double radius, required Color color}) {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    color: color,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
  );
}

const List<IconData> departmentIcons = [
  Icons.pool,
  Icons.sports_soccer,
  Icons.sports_handball,
];
const List<String> departmentName = [
  'سباحة',
  "كرة قدم",
  "كرة يد",
];

const List<String> evaluationGrade = [
  'ممتاز',
  "جيد جدا",
  "جيد",
  "مقبول",
];

const List<String> daysNames = [
  'الاِثْنَيْن',
  "الثُّلاثاء",
  "الأَرْبِعاء",
  "الخَميس",
  "الجُمْعَة",
  "السَّبْت",
  "الأَحَد",
];

ThemeData textData() {
  return ThemeData(
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontFamily: "AlmaraiExtraBold",
        fontSize: 24,
        color: kTextColor,
      ),
      subtitle1: TextStyle(
        fontFamily: "AlmaraiBold",
        fontSize: 17,
        color: kTextColor,
      ),
      bodyText1: TextStyle(
        fontFamily: "AlmaraiRegular",
        fontSize: 16,
        color: kTextColor,
      ),
      subtitle2: TextStyle(
        fontFamily: "AlmaraiLight",
        fontSize: 18,
        color: kTextColor,
      ),
      bodyText2: TextStyle(
        fontFamily: "AlmaraiExtraBold",
        fontSize: 12,
        color: kTextColor,
      ),
    ),
    backgroundColor: kBackgroundColor,
  );
}
