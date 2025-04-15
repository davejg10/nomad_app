import 'package:flutter/material.dart';

const EdgeInsets kSidePadding = EdgeInsets.fromLTRB(7, 0, 7, 0);
const TextStyle kAppBarTextStyle = TextStyle();
const TextStyle kHeaderTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
const TextStyle kSubHeaderTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w900
);
const TextStyle kNormalTextStyle = TextStyle(
  fontSize: 15,
    color: Colors.black87
);

const double kStandardIconSize = 16;

const kSnackBarDuration = Duration(seconds: 1);
const kAnimationDuration = Duration(milliseconds: 350);
const kAnimationCurve = Curves.easeInOut;

const BorderRadiusGeometry kCurvedTopEdges = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);

const double kShapeRadius = 8.0;
var kContainerShape = BorderRadius.circular(kShapeRadius);
var kButtonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius));
const EdgeInsets kButtonPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 12); // Internal padding for buttons

// const kIconButtonPadding =
const kIconButtonElevation = 3.0;
const kCardLowElevation = 2.0;
const kCardElevation = 5.0;
const kCardPadding = EdgeInsets.all(12.0);
const kCardMargin = EdgeInsets.only(left: 2.0, right: 2.0, bottom: 7.5, top: 10.0);
var kCardBorderRadius = BorderRadius.circular(20.0);

const kFontWeight = FontWeight.w600;

const kSearchBarPadding = EdgeInsets.only(top: 8.0, bottom: 8.0);


