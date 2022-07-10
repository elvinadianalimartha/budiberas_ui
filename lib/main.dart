import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/address_management_provider.dart';
import 'package:skripsi_budiberas_9701/providers/places_provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/providers/cart_provider.dart';
import 'package:skripsi_budiberas_9701/providers/category_provider.dart';
import 'package:skripsi_budiberas_9701/providers/message_provider.dart';
import 'package:skripsi_budiberas_9701/providers/order_confirmation_provider.dart';
import 'package:skripsi_budiberas_9701/providers/page_provider.dart';
import 'package:skripsi_budiberas_9701/providers/product_provider.dart';
import 'package:skripsi_budiberas_9701/providers/shop_info_provider.dart';
import 'package:skripsi_budiberas_9701/providers/user_detail_provider.dart';
import 'package:skripsi_budiberas_9701/splash_page.dart';
import 'package:skripsi_budiberas_9701/views/form/add_address.dart';
import 'package:skripsi_budiberas_9701/views/form/login_form.dart';
import 'package:skripsi_budiberas_9701/views/main/main_page.dart';
import 'package:skripsi_budiberas_9701/views/order_confirmation_page.dart';
import 'package:skripsi_budiberas_9701/views/profile_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (context) => CategoryProvider(),),
        ChangeNotifierProvider(create: (context) => AuthProvider(),),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, UserDetailProvider>(
          create: (_) => UserDetailProvider(),
          update: (_, authProvider, userDetailProvider) => userDetailProvider!
            ..user = authProvider.user! //set nilai user yg ada di dlm kelas UserDetailProvider dgn nilai user dr authProvider
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderConfirmationProvider>(
          create: (_) => OrderConfirmationProvider(),
          update: (_, authProvider, orderConfirmProvider) => orderConfirmProvider!
            ..user = authProvider.user!
        ),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
        ChangeNotifierProxyProvider<OrderConfirmationProvider, ShopInfoProvider>(
          create: (_) => ShopInfoProvider(),
          update: (_, orderConfirmProvider, shopInfoProvider) => shopInfoProvider!
            ..orderTotalPrice = orderConfirmProvider.confirmCountTotalPrice()
        ),
        ChangeNotifierProvider(create: (context) => PlacesProvider()),
        ChangeNotifierProxyProvider<AuthProvider, AddressManagementProvider>(
          create: (_) => AddressManagementProvider(),
          update: (_, authProvider, addressManageProvider) => addressManageProvider!
            ..user = authProvider.user!,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => MainPage(),
          '/sign-in': (context) => LoginForm(),
          '/profile': (context) => ProfilePage(),
          '/order-confirmation': (context) => OrderConfirmationPage(),
          '/add-address': (context) => FormAddAddress(),
        },
      ),
    );
  }
}
