import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/page_provider.dart';
import 'package:skripsi_budiberas_9701/providers/product_provider.dart';
import 'package:skripsi_budiberas_9701/splash_page.dart';
import 'package:skripsi_budiberas_9701/views/detail_product_page.dart';
import 'package:skripsi_budiberas_9701/views/main/cart_page.dart';
import 'package:skripsi_budiberas_9701/views/main/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageProvider(),),
        ChangeNotifierProvider(create: (context) => ProductProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => MainPage(),
          '/cart': (context) => CartPage(),
        },
      ),
    );
  }
}
