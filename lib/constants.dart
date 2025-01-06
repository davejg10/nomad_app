import 'package:flutter/material.dart';

const EdgeInsets kSidePadding = EdgeInsets.fromLTRB(15, 0, 15, 0);
const TextStyle kAppBarTextStyle = TextStyle();

const BorderRadiusGeometry kCurvedTopEdges = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);

const kCardElevation = 5.0;
const kCardPadding = EdgeInsets.all(8.0);
const kFontWeight = FontWeight.w600;
const kSunkenBoxDecoration = BoxDecoration(
  boxShadow: [
    const BoxShadow(
      color: Colors.black,
    ),
    const BoxShadow(
      color: Color(0xFF1D1E33),
      spreadRadius: -2.0,
      blurRadius: 8.0,
    ),
  ],
  borderRadius: BorderRadius.all(Radius.circular(12.0))
);

const kSearchBarPadding = EdgeInsets.only(top: 8.0, bottom: 8.0);
