import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/cancel_button.dart';

class EmailResetSentPage extends StatelessWidget {
  const EmailResetSentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content() {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/email_sent.png', width: MediaQuery.of(context).size.width/3,),
            const SizedBox(height: 20,),
            Text(
              'Periksa email Anda',
              style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18),
            ),
            const SizedBox(height: 8,),
            Text(
              'Instruksi untuk mengatur ulang kata sandi telah Budi Beras kirimkan ke email Anda. '
                  '\nJika tidak menemukannya, mohon cek pada bagian "spam"'
                  '\n\nSilakan ikuti instruksinya, lalu kembali login pada aplikasi ini.',
              style: greyTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CancelButton(
                onClick: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                },
                text: 'Kembali',
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: content()
        ),
      ),
    );
  }
}
