import 'package:flutter/material.dart';

import '../util/dimensions.dart';



ThemeData dark = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: Color(0xFF252525),
  brightness: Brightness.dark,
  hintColor: Color(0xFFc7c7c7),
);
ThemeData light = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: Color(0xFFEFEDED),
  brightness: Brightness.light,
  hintColor: Color(0xFF9E9E9E),
);

const titilliumRegular = TextStyle(
  fontFamily: 'TitilliumWeb',
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
);

const titilliumSemiBold = TextStyle(
  fontFamily: 'TitilliumWeb',
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
  fontWeight: FontWeight.w600,
);

const titilliumBold = TextStyle(
  fontFamily: 'TitilliumWeb',
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
  fontWeight: FontWeight.w700,
);
const titilliumItalic = TextStyle(
  fontFamily: 'TitilliumWeb',
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
  fontStyle: FontStyle.italic,
);

const robotoRegular = TextStyle(
  fontFamily: 'Roboto',
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
);

const robotoBold = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

const chakraPetch = TextStyle(
  fontFamily: 'ChakraPetch',
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
  fontWeight: FontWeight.w700,
);
const robotoSlab = TextStyle(
  fontFamily: 'RobotoSlab',
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
  fontWeight: FontWeight.w700,
);
