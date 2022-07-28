import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../theme.dart';

class TransUpdateBtn extends StatelessWidget {
  final VoidCallback? onClick;
  final String? text;
  final double? fontSize;

  const TransUpdateBtn({
    Key? key,
    this.onClick,
    this.text,
    this.fontSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: btnColor.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(3, 3),
          )
        ]
      ),
      child: TextButton(
          onPressed: onClick,
          style: TextButton.styleFrom(
            backgroundColor: btnColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
            padding: const EdgeInsets.all(12),
          ),
          child: Text(
            text!,
            style: whiteTextStyle.copyWith(
              fontSize: fontSize,
              fontWeight: medium,
            ),
          )
      ),
    );
  }
}

