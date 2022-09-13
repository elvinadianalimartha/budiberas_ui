import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/loading_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/text_field.dart';

import '../../providers/auth_provider.dart';

class FillEmailForResetPassForm extends StatefulWidget {
  const FillEmailForResetPassForm({Key? key}) : super(key: key);

  @override
  State<FillEmailForResetPassForm> createState() => _FillEmailForResetPassFormState();
}

class _FillEmailForResetPassFormState extends State<FillEmailForResetPassForm> {
  TextEditingController emailCtrl = TextEditingController(text: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loadingSend = false;

  @override
  Widget build(BuildContext context) {
    Widget backBtn() {
      return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)
      );
    }

    handleEmailingForgotPass() async{
      setState(() {
        loadingSend = true;
      });
      if(await context.read<AuthProvider>().forgotPassword(email: emailCtrl.text)) {
        Navigator.pushNamed(context, '/email-reset-pass-sent');
        emailCtrl.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Email gagal dikirim'), backgroundColor: alertColor, duration: const Duration(seconds: 1),),
        );
      }
      setState(() {
        loadingSend = false;
      });
    }

    Widget formEmail() {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            const SizedBox(height: 4,),
            TextFormFieldWidget(
              hintText: 'Masukkan email Anda',
              controller: emailCtrl,
              validator: (value) {
                if(value!.isEmpty) {
                  return 'Masukkan email Anda';
                } else if(!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 50,),
            loadingSend
              ? const LoadingButton(text: 'Sedang Mengirim')
              : SizedBox(
              width: MediaQuery.of(context).size.width,
                child: DoneButton(
                    text: 'Kirim Instruksi',
                    onClick: () {
                      if(_formKey.currentState!.validate()) {
                        handleEmailingForgotPass();
                      }
                    },
                  ),
              )
          ],
        ),
      );
    }

    Widget content() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.centerLeft, child: backBtn()),
            const SizedBox(height: 20,),
            Text(
              'Atur Ulang Kata Sandi',
              style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            ),
            const SizedBox(height: 8,),
            Text(
              'Masukkan email akun Anda supaya kami dapat mengirimkan instruksi '
                  'untuk mengatur ulang kata sandi Anda',
              style: greyTextStyle,
            ),
            const SizedBox(height: 12,),
            formEmail()
          ],
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(child: content()),
    );
  }
}
