import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class AlertDialogWidget extends StatelessWidget {
  final String text;
  String? noteText;
  final List<Widget>? childrenList;

  AlertDialogWidget({
    Key? key,
    required this.text,
    this.noteText,
    this.childrenList,
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
                decoration: const BoxDecoration(
                  color: Color(0xffffdeeb),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.question_mark, size: 30, color: alertColor,)),
            const SizedBox(height: 12,),
            Text(
              text,
              style: primaryTextStyle.copyWith(fontSize: 15), textAlign: TextAlign.center,
            ),
            noteText != null
              ? Text(
                noteText!,
                style: greyTextStyle.copyWith(fontSize: 15), textAlign: TextAlign.center,
              )
              : const SizedBox(),
            SizedBox(height: defaultMargin,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: childrenList!
            )
          ],
        ),
      ),
    );
  }
}
