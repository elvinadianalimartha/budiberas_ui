import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/text_field.dart';

import '../../providers/auth_provider.dart';
import '../widgets/reusable/loading_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  late SharedPreferences loginData;

  bool _notVisible = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    handleLogin(AuthProvider authProvider) async {
      setState(() {
        _loading = true;
      });

      if(await authProvider.login(email: emailController.text, password: passwordController.text)) {
        loginData = await SharedPreferences.getInstance();
        loginData.setString('email', emailController.text);
        loginData.setString('password', passwordController.text);
        Navigator.pushNamed(context, '/home');
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Gagal masuk! Email atau kata sandi salah',
                //textAlign: TextAlign.center,
              ),
              backgroundColor: alertColor,
              duration: const Duration(milliseconds: 700),
            )
        );
      }

      setState(() {
        _loading = false;
      });
    }

    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masuk',
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4,),
          Text(
            'Masuk untuk berbelanja',
            style: secondaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 12,),
          Center(
            child: Image.asset('assets/login_image.png', width: MediaQuery.of(context).size.width/2,),
          ),
          const SizedBox(height: 12,),
        ],
      );
    }

    Widget emailField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alamat email',
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            controller: emailController,
            hintText: 'Masukkan alamat email Anda',
            prefixIcon: Icon(Icons.email, size: 20, color: secondaryColor,),
            validator: (value) {
              if(value!.isEmpty) {
                return 'Mohon isi email Anda';
              } else if(!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget passwordField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kata sandi',
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            controller: passwordController,
            hintText: 'Masukkan kata sandi',
            obscureText: _notVisible,
            prefixIcon: Icon(Icons.lock, size: 20, color: secondaryColor,),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _notVisible = !_notVisible;
                });
              },
              child: Icon(
                  _notVisible ? Icons.visibility : Icons.visibility_off,
                  size: 20
              )
            ),
            validator: (value) {
              if(value!.isEmpty) {
                return 'Mohon isi kata sandi akun Anda';
              }
            },
          ),
        ],
      );
    }

    Widget forgotPass() {
      return Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {  },
          child: Text(
            'Lupa kata sandi?',
            style: alertTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    Widget form() {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            emailField(),
            const SizedBox(height: 20,),
            passwordField(),
            forgotPass(),
            const SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return _loading
                   ? const LoadingButton()
                   : DoneButton(
                    text: 'Masuk',
                    onClick: () {
                      if(_formKey.currentState!.validate()) {
                        handleLogin(authProvider);
                      }
                    },
                  );
                }
              ),
            ),
          ],
        )
      );
    }

    Widget footer() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Anda belum punya akun? ',
                  style: greyTextStyle.copyWith(
                    fontWeight: semiBold,
                  )
                ),
                TextSpan(
                    text: 'Daftar sekarang',
                    style: priceTextStyle.copyWith(
                      fontWeight: semiBold,
                    )
                ),
              ]
            )
          )
        ],
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            header(),
            form(),
            const SizedBox(height: 20,),
            footer(),
          ],
        ),
      ),
    );
  }
}
