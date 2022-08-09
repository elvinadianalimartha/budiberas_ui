import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/form/registration_form_2.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/btn_with_icon.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/text_field.dart';

class RegistrationFormPage1 extends StatefulWidget {
  const RegistrationFormPage1({Key? key}) : super(key: key);

  @override
  State<RegistrationFormPage1> createState() => _RegistrationFormPage1State();
}

class _RegistrationFormPage1State extends State<RegistrationFormPage1> {
  final _regisForm1Key = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  bool _notVisible = true;

  @override
  Widget build(BuildContext context) {
    Widget back() {
      return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back)
      );
    }

    Widget header() {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Akun',
              style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
            ),
            Text(
              'Daftarkan akun Anda supaya bisa berbelanja di Budi Beras',
              style: greyTextStyle,
            ),
          ],
        ),
      );
    }

    Widget fieldName() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama',
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
          ),
          TextFormFieldWidget(
            hintText: 'Masukkan nama Anda',
            prefixIcon: Icon(Icons.account_circle, color: secondaryColor,),
            controller: nameController,
            validator: (value) {
              if(value!.isEmpty) {
                return 'Mohon isi nama Anda';
              }
              return null;
            },
          )
        ],
      );
    }

    Widget fieldEmail() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alamat email',
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
          ),
          TextFormFieldWidget(
            hintText: 'Masukkan alamat email Anda',
            prefixIcon: Icon(Icons.email, color: secondaryColor,),
            controller: emailController,
            validator: (value) {
              if(value!.isEmpty) {
                return 'Mohon isi email Anda';
              } else if(!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Format email tidak valid';
              }
              return null;
            },
          )
        ],
      );
    }

    Widget fieldPassword() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kata sandi',
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
          ),
          TextFormFieldWidget(
            controller: passwordController,
            hintText: 'Masukkan kata sandi',
            obscureText: _notVisible,
            prefixIcon: Icon(Icons.lock, color: secondaryColor,),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _notVisible = !_notVisible;
                  });
                },
                child: Icon(
                    _notVisible ? Icons.visibility_off : Icons.visibility,
                    size: 20
                )
            ),
            validator: (value) {
              if(value!.isEmpty) {
                return 'Mohon isi kata sandi akun Anda';
              } else if(value.length < 8) {
                return 'Kata sandi minimal 8 karakter';
              }
              return null;
            },
          )
        ],
      );
    }

    Widget allContent() {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _regisForm1Key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  back(),
                  header(),
                  const SizedBox(height: 20,),
                  fieldName(),
                  const SizedBox(height: 20,),
                  fieldEmail(),
                  const SizedBox(height: 20,),
                  fieldPassword(),
                  const SizedBox(height: 50,),
                  BtnWithIcon(
                    text: 'Selanjutnya',
                    onClick: () {
                      if(_regisForm1Key.currentState!.validate()) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationFormPage2(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        )));
                      }
                    },
                  )
                ],
              ),
            ),
          )
      );
    }

    return Scaffold(
      body: allContent(),
    );
  }
}
