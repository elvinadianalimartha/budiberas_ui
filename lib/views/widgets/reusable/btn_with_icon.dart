import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skripsi_budiberas_9701/theme.dart';

class BtnWithIcon extends StatelessWidget {
  final VoidCallback? onClick;
  final String text;
  final double? fontSize;
  final Color backgroundColor;

  const BtnWithIcon({
    Key? key,
    this.onClick,
    required this.text,
    this.fontSize = 16,
    this.backgroundColor = const Color(0xffF59F02),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: whiteTextStyle.copyWith(
              fontSize: fontSize,
              fontWeight: semiBold,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white,),
        ],
      ),
    );
  }
}
