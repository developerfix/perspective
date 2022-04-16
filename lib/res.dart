import 'package:adobe_xd/page_link.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

const int blueColor = 0xff3B5998;
const int redColor = 0xffEE6C4D;
const int blackColor = 0xff1D1A2F;

const String howSocietyAroundMeFunctions = 'How society around me functions';
const String whatsHappeningInMyCountry = 'What’s happening in my country';
const String whatsHappeningAroundTheWorld = 'What’s happening around the world';
const String mySenseOfBelongingAndItsRepresentation =
    'My sense of belonging and it’s representation';
const String whatISeeOnMyTV = 'What I see online or on my TV';
const String myLifestyle = 'My Lifestyle';
const String myReligion = 'My Religion';
const String myIdentity = 'My identity';
const String moneyAndFinances = 'Money and finances';

const String veryConservative = 'Very Conservative';
const String conservative = 'Conservative';
const String neutral = 'Neutral';
const String liberal = 'Liberal';
const String veryLiberal = 'Very Liberal';

//for all the text in the app
Widget txt(
    {String? txt,
    FontWeight? fontWeight,
    double? fontSize,
    Color? fontColor,
    int? maxLines}) {
  return AutoSizeText(
    txt!,
    maxLines: maxLines ?? 2,
    maxFontSize: fontSize!,
    minFontSize: fontSize - 5,
    style: TextStyle(
      fontFamily: 'OpenSans',
      // fontSize: fontSize,
      color: fontColor ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.w600,
    ),
  );
}

Widget navigator({Widget? child, Widget? function}) {
  return PageLink(links: [
    PageLinkInfo(
        transition: LinkTransition.Fade,
        ease: Curves.easeOut,
        duration: 0.3,
        pageBuilder: () => function),
  ], child: child!);
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

Widget textField(
    {TextEditingController? controller,
    BuildContext? context,
    bool? isobscuretext,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    int? maxlines,
    String? hinttext}) {
  return Theme(
      data: Theme.of(context!).copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: const Color(blackColor),
            ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffefeff2),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 1.0, color: const Color(0xffe1e1e5)),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: isobscuretext ?? false,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxlines ?? 1,
          // validator: widget.validator as String? Function(String?)? ?? null,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            color: Color(blackColor),
          ),

          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon ?? const Text(''),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xffe1e1e5), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(blackColor), width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xffe1e1e5), width: 1.0),
            ),
            contentPadding: const EdgeInsets.all(10),
            hintText: hinttext ?? 'Email',
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'OpenSans',
              fontSize: 14,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ),
      ));
}
