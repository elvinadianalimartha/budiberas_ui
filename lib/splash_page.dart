import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/providers/category_provider.dart';
import 'package:skripsi_budiberas_9701/providers/product_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    getInit();
    super.initState();
  }

  getInit() async{
    await Future.wait([
      Provider.of<CategoryProvider>(context, listen: false).getCategories(),
      Provider.of<ProductProvider>(context, listen: false).getProducts(),
    ]);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    //NOTE: get data login yg tersimpan di shared preference (diset saat login)
    SharedPreferences loginData = await SharedPreferences.getInstance();
    var email = loginData.getString('email');
    var password = loginData.getString('password');

    if(email != '') {
      await authProvider.login(email: email, password: password);
    }
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Image.asset('assets/big_logo.png', width: MediaQuery.of(context).size.width/1.5,),
      ),
    );
  }
}
