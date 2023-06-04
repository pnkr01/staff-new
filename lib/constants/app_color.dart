import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

const whiteColor = Colors.white;
const blackColor = Colors.black;
const purpleColor = Colors.purple;
const greyColor = Color(0xffC4C4C4);

TextStyle kTitleTextStyle(double fontsize, FontWeight weight) {
  return GoogleFonts.montserrat(
      fontSize: fontsize, fontWeight: weight, color: blackColor);
}

TextStyle kBodyText3Style() {
  return GoogleFonts.montserrat(
    fontWeight: FontWeight.w600,
    color: greyColor,
    fontSize: 12,
  );
}

TextStyle kBodyText4Style() {
  return GoogleFonts.montserrat(
    fontWeight: FontWeight.w600,
    color: blackColor,
    fontSize: 12,
  );
}

TextStyle kElevatedButtonTextStyle() {
  return GoogleFonts.montserrat(
    fontWeight: FontWeight.w600,
    color: blackColor,
    fontSize: 14,
  );
}

void staffPrint(message) {
  if (kDebugMode) {
    print(message.toString());
  }
  //log(message.toString());
}

showSnackBar(var message, Color backgroundColor, Color? textColor) {
  return Get.rawSnackbar(
    titleText: Text(
      'Staff Sathi',
      style: kBodyText4Style().copyWith(color: textColor),
    ),
    messageText: Text(
      message.toString(),
      style: kBodyText4Style().copyWith(color: textColor),
    ),
    // message: message,
    backgroundColor: backgroundColor,
    icon: Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      child: backgroundColor == purpleColor
          ? Lottie.asset('assets/lottie/loading_white.json')
          : Lottie.asset('assets/lottie/loading.json'),
    ),
  );
}
