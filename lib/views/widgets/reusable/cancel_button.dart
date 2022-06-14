import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback? onClick;
  final String? text;
  final double? fontSize;

  const CancelButton({
    Key? key,
    this.onClick,
    this.text = 'Batal',
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onClick,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: outlinedBtnColor,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24
          ),
        ),
        child: Text(
          text!,
          style: greyTextStyle.copyWith(
            fontSize: fontSize,
            fontWeight: medium,
          ),
        )
    );
  }
}