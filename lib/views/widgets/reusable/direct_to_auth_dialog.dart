import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';
import 'done_button.dart';

class DirectToAuthDialog extends StatelessWidget {
  const DirectToAuthDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      //width: MediaQuery.of(context).size.width - (2 * defaultMargin),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/auth_first.png', width: 90,),
              const SizedBox(height: 10,),
              Text(
                'Ups! Kami belum mengenali Anda',
                textAlign: TextAlign.center,
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                'Daftar/masuk dulu yuk, supaya bisa menikmati fitur ini 😉',
                textAlign: TextAlign.center,
                style: greyTextStyle,
              ),
              const SizedBox(height: 20,),
              DoneButton(
                fontSize: 14,
                text: 'Masuk ke Akun Saya',
                onClick: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/sign-in');
                },
              ),
              const SizedBox(height: 16,),
              TextButton(
                onPressed: () {  },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: btnColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Daftar Sekarang', style: yellowTextStyle.copyWith(fontWeight: medium)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
