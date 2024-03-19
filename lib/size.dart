import 'package:flutter/material.dart';

const  double referenceWidth = 448.0; //Pixel 8 Pro Width
const  double referenceHeight = 973.3333333333334; //Pixel 8 Pro Height

//create a function that will help us to get the dynamic height
double dynamicHeight(double value, BuildContext context) {
  double dynamicheight = value * MediaQuery.of(context).size.height / referenceHeight;
  return dynamicheight;
}

//create a function that will help us to get the dynamic width
double dynamicWidth(double value, BuildContext context) {
  double dynamicwidth = value * MediaQuery.of(context).size.width / referenceWidth;
  return dynamicwidth;
}

//create a function that will help us to get the dynamic font size
double dynamicFontSize(double value, BuildContext context) {
  double dynamicfontsize = value * MediaQuery.of(context).size.width / referenceWidth;
  return dynamicfontsize;
}

//create a function that will help us to get the dynamic padding
EdgeInsets dynamicPadding(double top, double bottom, double left, double right, BuildContext context) {
  return EdgeInsets.fromLTRB(dynamicWidth(left, context), dynamicHeight(top, context), dynamicWidth(right, context), dynamicHeight(bottom, context));
}

//create a function that will help us to get the dynamic margin
EdgeInsets dynamicMargin(double top, double bottom, double left, double right, BuildContext context) {
  return EdgeInsets.fromLTRB(dynamicWidth(left, context), dynamicHeight(top, context), dynamicWidth(right, context), dynamicHeight(bottom, context));
}