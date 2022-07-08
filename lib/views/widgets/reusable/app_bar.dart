import 'package:flutter/material.dart';

import '../../../theme.dart';

AppBar customAppBar({
  required String text,
  PreferredSizeWidget? bottom,
}) {
  return AppBar(
    backgroundColor: primaryColor,
    elevation: 0,
    centerTitle: true,
    title: Text(
      text,
      style: whiteTextStyle.copyWith(
        fontWeight: semiBold,
        fontSize: 16,
      ),
    ),
    bottom: bottom, //utk taruh tabs
  );
}