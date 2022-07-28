import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class StatusDialogWidget extends StatelessWidget {
  final String text;
  final Color backgroundColorIcon;
  final IconData icon;
  final Color colorIcon;

  const StatusDialogWidget({
    Key? key,
    required this.text,
    required this.backgroundColorIcon,
    required this.icon,
    required this.colorIcon,
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
                  color: backgroundColorIcon.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(icon, size: 50, color: colorIcon,)
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
