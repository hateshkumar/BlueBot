import 'package:flutter/material.dart';

import '../../../config/theme/bluebot_themes.dart';

class BlueBotText extends Text {
  BlueBotText.headerText({
    super.key,
    String? text,
    double? fontSize,
    TextAlign? textAlign,
    Color? color,
  }) : super(text!,
            textAlign: textAlign ?? TextAlign.center,
            style: BlueBotTheme.themeData.textTheme.displayLarge.copyWith(fontSize: fontSize,color: color));

  BlueBotText.subHeaderText({
    super.key,
    String? text,
    int? maxLines,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    double? letterSpacing,
    double? height,
    double? wordSpacing,
    TextDecoration? textDecoration,
  }) : super(text!,
            maxLines: maxLines,
            textAlign: textAlign ?? TextAlign.center,
            overflow: overflow ?? TextOverflow.visible,
            style: BlueBotTheme.themeData.textTheme.labelSmall
                .copyWith(color: color ?? const Color(0xff000000), fontSize: fontSize ?? 14,
                fontWeight: fontWeight ?? FontWeight.normal,height: height ?? 0 ,letterSpacing: letterSpacing,wordSpacing: wordSpacing,decoration: textDecoration));
}
