import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double getDynamicHeight(BuildContext context, double value) =>
    MediaQuery.of(context).size.height * value;
double getDynamicWidth(BuildContext context, double value) =>
    MediaQuery.of(context).size.width * value;

SizedBox emptySpaceHeight(BuildContext context, double value) => SizedBox(
    height: MediaQuery.of(context).size.height * value, child: const Text(''));
SizedBox emptySpaceWidth(BuildContext context, double value) => SizedBox(
    width: MediaQuery.of(context).size.width * value, child: const Text(''));

// Date Formatter

String dateFormatterMonthDay(DateTime? date) {
  final formatter = DateFormat("MMM d");
  return formatter.format(date!);
}

String dateFormatterYearMonthDay(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}