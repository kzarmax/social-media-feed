import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

InputDecoration textInputDecoration({required String hint}) {
  return InputDecoration(
    labelText: hint,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: TextStyle(
      color: inputHintTextColor,
      fontSize: 14.sp,
      fontFamily: 'HiraKakuProW3',
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
    border: const OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
    disabledBorder: InputBorder.none,
    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: inputFocusBorderColor)),
    isDense: true,
    filled: true,
    fillColor: inputFilledColor,
    errorStyle: TextStyle(fontSize: 12.sp, height: 1, fontFamily: 'HiraKakuProW3', color: errorColor),
  );
}

TextStyle primaryTextStyle({bool bold = false}) {
  return TextStyle(fontSize: 14.sp, color: textPrimaryColor, fontFamily: bold ? "HiraKakuProW6" : "HiraKakuProW3");
}

TextStyle secondaryTextStyle({bool bold = false}) {
  return TextStyle(fontSize: 14.sp, color: Colors.grey, fontFamily: bold ? "HiraKakuProW6" : "HiraKakuProW3");
}

TextStyle whiteTextStyle({bool bold = false}) {
  return TextStyle(fontSize: 14.sp, color: textWhiteColor, fontFamily: bold ? "HiraKakuProW6" : "HiraKakuProW3");
}