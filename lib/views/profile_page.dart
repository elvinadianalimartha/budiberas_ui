import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/cancel_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // UserModel? user = Provider.of<AuthProvider>(context).user;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel? user = authProvider.user;

    SharedPreferences loginData;

    Widget settingOption() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan Profil',
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Data Diri',
                  style: primaryTextStyle,
                ),
                Icon(Icons.chevron_right, color: secondaryTextColor,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ubah Kata Sandi',
                  style: primaryTextStyle,
                ),
                Icon(Icons.chevron_right, color: secondaryTextColor,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Alamat',
                  style: primaryTextStyle,
                ),
                Icon(Icons.chevron_right, color: secondaryTextColor,)
              ],
            ),
          ),
        ],
      );
    }

    handleLogout() async{
      if(await authProvider.logout(user!.token!)) {
        authProvider.user = null;
        loginData = await SharedPreferences.getInstance();
        loginData.remove('email');
        loginData.remove('password');
        //kayaknya perlu pop jg di sini
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Gagal logout',
              ),
              backgroundColor: alertColor,
              duration: const Duration(milliseconds: 700),
            )
        );
      }
    }

    Future<void> showDialogAreYouSure() async{
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
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
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.question_mark, size: 30, color: alertColor,)
                ),
                const SizedBox(height: 12,),
                Text(
                  'Apakah Anda yakin ingin keluar dari aplikasi?',
                  style: primaryTextStyle, textAlign: TextAlign.center,
                ),
                SizedBox(height: defaultMargin,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CancelButton(
                      onClick: () {
                        Navigator.pop(context);
                      },
                      text: 'Tidak',
                      fontSize: 14,
                    ),
                    const SizedBox(width: 36,),
                    DoneButton(
                      onClick: () {
                        handleLogout();
                      },
                      text: 'Ya, keluar',
                      fontSize: 14,
                    )
                  ]
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget logout() {
      return GestureDetector(
        onTap: () {
          showDialogAreYouSure();
        },
        child: Row(
          children: [
            Icon(Icons.logout, color: alertColor,),
            const SizedBox(width: 8,),
            Text(
              'Keluar',
              style: primaryTextStyle,
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        toolbarHeight: 100,
        centerTitle: true,
        title: Container(
          color: primaryColor,
          child: Row(
            children: [
              Image.asset('assets/profile_image.png', width: 65,),
              const SizedBox(width: 16,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${user?.name}',
                      style: whiteTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      '${user?.email}',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          settingOption(),
          const Divider(thickness: 2,),
          const SizedBox(height: 12,),
          logout(),
        ],
      ),
    );
  }
}
