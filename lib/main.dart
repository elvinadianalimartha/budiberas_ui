import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/firebase_options.dart';
import 'package:skripsi_budiberas_9701/providers/places_provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/providers/cart_provider.dart';
import 'package:skripsi_budiberas_9701/providers/category_provider.dart';
import 'package:skripsi_budiberas_9701/providers/message_provider.dart';
import 'package:skripsi_budiberas_9701/providers/order_confirmation_provider.dart';
import 'package:skripsi_budiberas_9701/providers/page_provider.dart';
import 'package:skripsi_budiberas_9701/providers/product_provider.dart';
import 'package:skripsi_budiberas_9701/providers/shop_info_provider.dart';
import 'package:skripsi_budiberas_9701/providers/transaction_provider.dart';
import 'package:skripsi_budiberas_9701/providers/user_detail_provider.dart';
import 'package:skripsi_budiberas_9701/splash_page.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/email_reset_sent_page.dart';
import 'package:skripsi_budiberas_9701/views/form/add_address.dart';
import 'package:skripsi_budiberas_9701/views/form/change_password.dart';
import 'package:skripsi_budiberas_9701/views/form/fill_reset_email_form.dart';
import 'package:skripsi_budiberas_9701/views/form/login_form.dart';
import 'package:skripsi_budiberas_9701/views/form/registration_form.dart';
import 'package:skripsi_budiberas_9701/views/main/main_page.dart';
import 'package:skripsi_budiberas_9701/views/order_confirmation_page.dart';
import 'package:skripsi_budiberas_9701/views/profile_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //foregroundNotification();
  runApp(const MyApp());
}

void foregroundNotification() async {
  // 1. Instantiate Firebase Messaging
  var messageInstance = FirebaseMessaging.instance;

  // 2. On iOS, this helps to take the user permissions
  NotificationSettings settings = await messageInstance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if(settings.authorizationStatus == AuthorizationStatus.authorized) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got message in foreground');

      if(message.notification != null) {
        showSimpleNotification(
            Text('📢  ${message.notification!.title!}', style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(message.notification!.body!, style: greyTextStyle.copyWith(fontSize: 13),),
            ),
            duration: Duration(seconds: 3),
            background: Color(0xffE5EFFA),
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 20)
        );
      }
    });
  } else {
    print('User declined or has not accepted permission');
  }
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
            ..user = authProvider.user //set nilai user yg ada di dlm kelas UserDetailProvider dgn nilai user dr authProvider
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderConfirmationProvider>(
          create: (_) => OrderConfirmationProvider(),
          update: (_, authProvider, orderConfirmProvider) => orderConfirmProvider!
            ..user = authProvider.user
        ),
        ChangeNotifierProxyProvider<AuthProvider, TransactionProvider>(
            create: (_) => TransactionProvider(),
            update: (_, authProvider, transProvider) => transProvider!
              ..user = authProvider.user
        ),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
        ChangeNotifierProxyProvider<OrderConfirmationProvider, ShopInfoProvider>(
          create: (_) => ShopInfoProvider(),
          update: (_, orderConfirmProvider, shopInfoProvider) => shopInfoProvider!
            ..orderTotalPrice = orderConfirmProvider.confirmCountTotalPrice()
        ),
        ChangeNotifierProvider(create: (context) => PlacesProvider()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('id', ''), // Indonesia, no country code
          ],
          routes: {
            '/': (context) => const SplashPage(),
            '/home': (context) => MainPage(),
            '/sign-in': (context) => LoginForm(),
            '/profile': (context) => ProfilePage(),
            '/order-confirmation': (context) => OrderConfirmationPage(),
            '/add-address': (context) => FormAddAddress(),
            '/registration': (context) => RegistrationFormPage1(),
            '/change-password': (context) => ChangePasswordForm(),
            '/fill-email-reset-pass': (context) => FillEmailForResetPassForm(),
            '/email-reset-pass-sent': (context) => EmailResetSentPage()
          },
        ),
      ),
    );
  }
}
