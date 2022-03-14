import 'dart:ui';

import 'package:flutter/material.dart';

// Login/SignUp HeadingElement
Text formHeading(var label) {
  return Text(label,
      style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'Bold'),
      textAlign: TextAlign.center);
}

//-------------------------------------------Form-------------------------------------------------------------------------
// EditText rounded Style
Padding editTextStyle(var hintText,
    {isPassword = true, TextEditingController? controller}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
    child: TextFormField(
      style: TextStyle(fontSize: 18.0, fontFamily: 'Regular'),
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
        hintText: hintText,
        filled: true,
        fillColor: Color(0XFFFFFFFF),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Color(0XFFF1F1F1), width: 0.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Color(0XFFF1F1F1), width: 0.0),
        ),
      ),
    ),
  );
}

Widget text(
  String? text, {
  double fontSize = 18.0,
  Color? textColor,
  var fontFamily,
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : text!,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily ?? null,
      fontSize: fontSize,
      color: textColor ?? Color(0xFF000000),
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color? bgColor,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    // boxShadow: showShadow ? defaultBoxShadow(shadowColor: shadowColorGlobal) : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Color(0XFF09efb1),
    leading: IconButton(
      onPressed: () {},
      icon: Icon(Icons.arrow_back, color: Colors.white),
    ),
    title: Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      color: Color(0XFF09efb1),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(),
            maxLines: 1,
          ),
        ],
      ),
    ),
  );
}

Widget ring(String description) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150.0),
          border: Border.all(width: 16.0, color: Color(0XFF09efb1)),
        ),
      ),
      SizedBox(height: 16),
      text(description, textColor: Colors.black, fontSize: 18.0, fontFamily: 'SemiBold', isCentered: true, maxLine: 2)
    ],
  );
}
