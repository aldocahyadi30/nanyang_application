import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

String formatCurrency(double value) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value);
}

double removeCurrencyFormat(String value) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).parse(value) as double;
}

CurrencyTextInputFormatter formatInputCurrencty() {
  return CurrencyTextInputFormatter.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
}

DateTime parseStringToDate(String date) {
  return DateTime.parse(date);
}

DateTime parseStringToDateWithTime(String date) {
  return DateFormat('yyyy-MM-dd HH:mm').parse(date);
}

DateTime parseStringToDateFormatted(String date) {
  return DateFormat('dd/MM/yyyy').parse(date);
}

DateTime parseStringToDateFormattedWithTime(String date) {
  return DateFormat('dd/MM/yyyy HH:mm').parse(date);
}

String parseDateToStringWithTime(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}

String parseDateToStringFormatted(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String parseDateToStringFormattedWithTime(DateTime date) {
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}

String parseDateToString(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String parseTimeToString(DateTime date) {
  return DateFormat('HH:mm').format(date);
}

MaskTextInputFormatter inputCurrencyFormatter = MaskTextInputFormatter(
  mask: '###.###.###.###.###',
  filter: {"#": RegExp(r'[0-9]')},
);

MaskTextInputFormatter inputDoubleFormatter = MaskTextInputFormatter(
  mask: '###,###,###,###,###.##',
  filter: {"#": RegExp(r'[0-9]')},
);

Uint8List yuv420ToNv21(CameraImage image) {
  final int width = image.width;
  final int height = image.height;

  final int ySize = width * height;
  final int uvSize = width * height ~/ 4;

  // Allocate NV21 buffer
  final Uint8List nv21 = Uint8List(ySize + uvSize * 2);

  // Copy Y plane
  nv21.setRange(0, ySize, image.planes[0].bytes);

  // Copy VU (NV21) plane from U and V planes
  int uvIndex = 0;
  for (int row = 0; row < height ~/ 2; row++) {
    for (int col = 0; col < width ~/ 2; col++) {
      nv21[ySize + uvIndex * 2] = image.planes[2].bytes[row * image.planes[2].bytesPerRow + col]; // V plane
      nv21[ySize + uvIndex * 2 + 1] = image.planes[1].bytes[row * image.planes[1].bytesPerRow + col]; // U plane
      uvIndex++;
    }
  }

  return nv21;
}
