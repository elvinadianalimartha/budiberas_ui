import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/app_bar.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/loading_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/text_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController currentPassCtrl = TextEditingController(text: '');
  TextEditingController newPassCtrl = TextEditingController(text: '');
  TextEditingController confirmNewPassCtrl = TextEditingController(text: '');

  bool isCheckOldPassTrue = false;
  bool isLoadingCheck = false;

  bool _notVisibleOldPass = true;
  bool _notVisibleNewPass = true;
  bool _notVisibleConfirmPass = true;

  @override
  Widget build(BuildContext context) {

    resetFields() {
      setState(() {
        currentPassCtrl.clear();
        newPassCtrl.clear();
        confirmNewPassCtrl.clear();
      });
    }

    Widget currentPassword() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kata sandi lama',
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
          ),
          const SizedBox(height: 4,),
          TextFormFieldWidget(
            autoValidateMode: AutovalidateMode.disabled,
            controller: currentPassCtrl,
            hintText: 'Masukkan kata sandi lama',
            obscureText: _notVisibleOldPass,
            prefixIcon: Icon(Icons.lock, size: 20, color: secondaryColor,),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _notVisibleOldPass = !_notVisibleOldPass;
                  });
                },
                child: Icon(
                    _notVisibleOldPass ? Icons.visibility_off : Icons.visibility,
                    size: 20
                )
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Kata sandi lama harus diisi';
              } else if(!isCheckOldPassTrue) {
                return 'Tidak sesuai dengan kata sandi lama';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget newPassword() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kata sandi baru',
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
          ),
          const SizedBox(height: 4,),
          TextFormFieldWidget(
            autoValidateMode: AutovalidateMode.disabled,
            controller: newPassCtrl,
            hintText: 'Masukkan kata sandi baru',
            obscureText: _notVisibleNewPass,
            prefixIcon: Icon(Icons.lock, size: 20, color: secondaryColor,),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _notVisibleNewPass = !_notVisibleNewPass;
                  });
                },
                child: Icon(
                    _notVisibleNewPass ? Icons.visibility_off : Icons.visibility,
                    size: 20
                )
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Kata sandi baru harus diisi';
              } else if(value.length < 8) {
                return 'Kata sandi minimal 8 karakter';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget confirmNewPassword() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Konfirmasi kata sandi baru',
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
          ),
          const SizedBox(height: 4,),
          TextFormFieldWidget(
            autoValidateMode: AutovalidateMode.disabled,
            controller: confirmNewPassCtrl,
            hintText: 'Konfirmasi kata sandi baru',
            obscureText: _notVisibleConfirmPass,
            prefixIcon: Icon(Icons.lock, size: 20, color: secondaryColor,),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _notVisibleConfirmPass = !_notVisibleConfirmPass;
                  });
                },
                child: Icon(
                    _notVisibleConfirmPass ? Icons.visibility_off : Icons.visibility,
                    size: 20
                )
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Kata sandi baru harus dikonfirmasi';
              } else if(value != newPassCtrl.text) {
                return 'Konfirmasi kata sandi harus sama dengan kata sandi baru';
              }
              return null;
            },
          ),
        ],
      );
    }

    handleCheckOldPass() async {
      setState(() {
        isLoadingCheck = true;
      });
      if(await context.read<AuthProvider>().checkOldPass(currentPassword: currentPassCtrl.text)) {
        setState(() {
          isCheckOldPassTrue = true;
        });
      } else {
        setState(() {
          isCheckOldPassTrue = false;
        });
      }
      setState(() {
        isLoadingCheck = false;
      });
    }

    handleChangePassword() async {
      if(await context.read<AuthProvider>().changePassword(
          currentPassword: currentPassCtrl.text,
          newPassword: newPassCtrl.text,
          confirmNewPassword: confirmNewPassCtrl.text
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Kata sandi berhasil diganti'),
            backgroundColor: secondaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
        resetFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Kata sandi gagal diganti'),
            backgroundColor: alertColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    Widget content() {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                currentPassword(),
                const SizedBox(height: 20,),
                newPassword(),
                const SizedBox(height: 20,),
                confirmNewPassword(),
                const SizedBox(height: 50,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: isLoadingCheck
                    ? const LoadingButton(text: 'Sedang memvalidasi',)
                    : DoneButton(
                        text: 'Simpan',
                        onClick: () {
                          if(currentPassCtrl.text != '') {
                            handleCheckOldPass();
                          }
                          if(_formKey.currentState!.validate() && isCheckOldPassTrue) {
                            handleChangePassword();
                          }
                        },
                      ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Ubah Kata Sandi'),
      body: content(),
    );
  }
}
