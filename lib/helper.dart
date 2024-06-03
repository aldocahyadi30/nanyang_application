import 'dart:math';

import 'package:flutter/material.dart';

const double referenceWidth = 448.0; // Pixel 8 Pro Width
const double referenceHeight = 973.3333333333334; // Pixel 8 Pro Height



// Create a function that will help us to get the dynamic height
double dynamicHeight(double value, BuildContext context) {
  return value * (MediaQuery.of(context).size.height / referenceHeight);
}

// Create a function that will help us to get the dynamic width
double dynamicWidth(double value, BuildContext context) {
  return value * (MediaQuery.of(context).size.width / referenceWidth);
}

// Create a function that will help us to get the dynamic font size
double dynamicFontSize(double value, BuildContext context) {
  double widthRatio = MediaQuery.of(context).size.width / referenceWidth;
  double heightRatio = MediaQuery.of(context).size.height / referenceHeight;

  return value * min(widthRatio, heightRatio);
}

// Create a function that will help us to get the dynamic padding
EdgeInsets dynamicPaddingOnly(double top, double bottom, double left, double right, BuildContext context) {
  return EdgeInsets.only(
    top: dynamicHeight(top, context),
    bottom: dynamicHeight(bottom, context),
    left: dynamicWidth(left, context),
    right: dynamicWidth(right, context),
  );
}

EdgeInsets dynamicPaddingAll(double value, BuildContext context) {
  return EdgeInsets.all(dynamicWidth(value, context));
}

EdgeInsets dynamicPaddingSymmetric(double vertical, double horizontal, BuildContext context) {
  return EdgeInsets.symmetric(
    vertical: dynamicHeight(vertical, context),
    horizontal: dynamicWidth(horizontal, context),
  );
}

// Create a function that will help us to get the dynamic margin
EdgeInsets dynamicMargin(double top, double bottom, double left, double right, BuildContext context) {
  return EdgeInsets.only(
    top: dynamicHeight(top, context),
    bottom: dynamicHeight(bottom, context),
    left: dynamicWidth(left, context),
    right: dynamicWidth(right, context),
  );
}