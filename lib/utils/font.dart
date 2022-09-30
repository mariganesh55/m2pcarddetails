import 'package:flutter/material.dart';

class Font {
  static const Font IlisarniqBlack = Font("Ilisarniq-Black");
  static const Font IlisarniqBlackItalic = Font("Ilisarniq-BlackItalic");
  static const Font IlisarniqBold = Font("Ilisarniq-Bold");
  static const Font IlisarniqBoldItalic = Font("Ilisarniq-BoldItalic");
  static const Font IlisarniqDemi = Font("Ilisarniq-Demi");
  static const Font IlisarniqDemiItalic = Font("Ilisarniq-DemiItalic");
  static const Font IlisarniqItalic = Font("Ilisarniq-Italic");
  static const Font IlisarniqLight = Font("Ilisarniq-Light");
  static const Font IlisarniqLightItalic = Font("Ilisarniq-LightItalic");
  static const Font IlisarniqRegular = Font("Ilisarniq-Regular");

  final String _fontName;

  const Font(this._fontName);

  String get value => _fontName;
}

class FontSize {
  static const double one = 1.0;
  static const double two = 2.0;
  static const double three = 3.0;
  static const double four = 4.0;
  static const double five = 5.0;
  static const double six = 6.0;
  static const double seven = 7.0;
  static const double eight = 8.0;
  static const double nine = 9.0;
  static const double ten = 10.0;
  static const double eleven = 11.0;
  static const double twelve = 12.0;
  static const double thirteen = 13.0;
  static const double fourteen = 14.0;
  static const double fifteen = 15.0;
  static const double sixteen = 16.0;
  static const double seventeen = 17.0;
  static const double eighteen = 18.0;
  static const double ninteen = 19.0;
  static const double twenty = 20.0;
  static const double twentyOne = 21.0;
  static const double twentyTwo = 22.0;
  static const double twentyThree = 23.0;
  static const double twentyFour = 24.0;
  static const double twentyFive = 25.0;
  static const double twentySix = 26.0;
  static const double twentySeven = 27.0;
  static const double twentyEight = 28.0;
  static const double twentyNine = 29.0;
  static const double thirty = 30.0;
  static const double thirtyOne = 31.0;
  static const double thirtyTwo = 32.0;
  static const double thirtyThree = 33.0;
  static const double thirtyFour = 34.0;
  static const double thirtyFive = 35.0;
}

class FontWeights {
  static const bold = FontWeight.bold;
  static const normal = FontWeight.normal;
}
