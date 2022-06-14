import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';

import '../theme.dart';

class DirectToAuthPage extends StatelessWidget {
  const DirectToAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/auth_first.png', width: MediaQuery.of(context).size.width/2.8,),
            const SizedBox(height: 10,),
            Text(
              'Ups! Kami belum mengenali Anda',
              style: primaryTextStyle.copyWith(
                fontWeight: semiBold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              'Daftar/masuk dulu yuk, supaya bisa menikmati fitur ini 😉',
              textAlign: TextAlign.center,
              style: greyTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20,),
            DoneButton(
              text: 'Masuk ke Akun Saya',
              onClick: () {
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
              child: Text('Daftar Sekarang', style: yellowTextStyle.copyWith(fontWeight: medium,fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
