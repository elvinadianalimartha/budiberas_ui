import 'package:flutter/material.dart';
import 'package:skripsi_budiberas_9701/theme.dart';

class LoadingButton extends StatelessWidget {
  final String text;

  const LoadingButton({
    Key? key,
    this.text = 'Memuat',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
          onPressed: (){},
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium
                ),
              ),
              const SizedBox(width: 8,),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    Colors.white,
                  ),
                ),
              ),
            ],
          )
      );
  }
}