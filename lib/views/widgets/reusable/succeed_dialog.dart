import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class SucceedDialogWidget extends StatelessWidget {
  final String text;

  const SucceedDialogWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(40),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: fourthColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.check_circle_rounded, size: 50, color: thirdColor,)
            ),
            const SizedBox(height: 12,),
            Text(
              text,
              style: primaryTextStyle, textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
