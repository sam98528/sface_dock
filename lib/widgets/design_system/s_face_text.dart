import 'package:flutter/material.dart';

class SFText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;
  final TextAlign textAlign;
  final int? maxLines;
  final double minFontSize;
  final List<Shadow>? shadow;
  final String? fontFamily;
  final double? height;
  final double? letterSpacing;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration;
  final double? decorationThickness;

  const SFText(
    this.text, {
    super.key,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 16,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.minFontSize = 12,
    this.shadow,
    this.height = 1,
    this.letterSpacing = 0,
    this.fontFamily = 'Pretendard',
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = true,
    this.decoration,
    this.decorationThickness,
  });

  factory SFText.pre(
    String text, {
    double fontSize = 16,
    int? maxLines,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.left,
    double minFontSize = 12,
    List<Shadow>? shadow,
    double? height,
    double? letterSpacing,
    TextOverflow? overflow,
    bool softWrap = false,
    TextDecoration? decoration,
    double? decorationThickness,
  }) {
    return SFText(
      text,
      fontFamily: 'Pretendard',
      fontSize: fontSize,
      maxLines: maxLines,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      minFontSize: minFontSize,
      shadow: shadow,
      height: height,
      letterSpacing: letterSpacing,
      overflow: overflow,
      softWrap: softWrap,
      decoration: decoration,
      decorationThickness: decorationThickness,
    );
  }

  factory SFText.bandoche(
    String text, {
    double fontSize = 16,
    int? maxLines,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.left,
    double minFontSize = 12,
    List<Shadow>? shadow,
    double? height,
    double? letterSpacing,
    TextOverflow? overflow,
    bool softWrap = false,
    TextDecoration? decoration,
    double? decorationThickness,
  }) {
    return SFText(
      text,
      fontFamily:
          'Pretendard', // Fallback to Pretendard, wait, actually 'LINESeedKR' or any given
      fontSize: fontSize,
      maxLines: maxLines,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      minFontSize: minFontSize,
      shadow: shadow,
      height: height,
      letterSpacing: letterSpacing,
      overflow: overflow,
      softWrap: softWrap,
      decoration: decoration,
      decorationThickness: decorationThickness,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: overflow,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        shadows: shadow,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
        decorationThickness: decorationThickness,
      ),
    );
  }
}
