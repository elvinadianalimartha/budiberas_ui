import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class DoneButton extends StatelessWidget {
  final VoidCallback? onClick;
  final String? text;
  final double? fontSize;

  const DoneButton({
    Key? key,
    this.onClick,
    this.text = 'Simpan',
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onClick,
        style: TextButton.styleFrom(
          backgroundColor: btnColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24
          ),
        ),
        child: Text(
          text!,
          style: whiteTextStyle.copyWith(
            fontSize: fontSize,
            fontWeight: medium,
          ),
        )
    );
  }
}