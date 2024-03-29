import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/message_provider.dart';
import 'package:skripsi_budiberas_9701/views/direct_to_auth_page.dart';
import 'package:skripsi_budiberas_9701/views/main/transaction_page.dart';
import 'package:skripsi_budiberas_9701/providers/page_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';

import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import 'cart_page.dart';
import 'chat_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    UserModel? user = Provider.of<AuthProvider>(context).user;

    Widget customBottomNav() {
      return Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow> [
            BoxShadow(color: const Color(0xff2895BD).withOpacity(0.3), blurRadius: 20.0),
          ]
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), //melengkung bagian atasnya aja, yg bawah engga
          child: BottomNavigationBar(
                currentIndex: pageProvider.currentIndex,
                onTap: (value) {
                  pageProvider.currentIndex = value;
                },
                type: BottomNavigationBarType.fixed, //untuk mengembalikan posisi icon spy pas di tengah
                items: [
                  BottomNavigationBarItem(
                      icon: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Image.asset(
                            'assets/icon_home.png',
                            width: 18,
                            color: pageProvider.currentIndex == 0 ? secondaryColor : secondaryTextColor,
                          )
                      ),
                      label: 'Beranda'
                  ),
                  BottomNavigationBarItem(
                      icon: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Image.asset(
                            'assets/icon_chat.png',
                            width: 19,
                            color: pageProvider.currentIndex == 1 ? secondaryColor : secondaryTextColor,
                          )
                      ),
                      label: 'Obrolan'
                  ),
                  BottomNavigationBarItem(
                      icon: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Image.asset(
                            'assets/icon_cart.png',
                            width: 17,
                            color: pageProvider.currentIndex == 2 ? secondaryColor : secondaryTextColor,)
                      ),
                      label: 'Keranjang'
                  ),
                  BottomNavigationBarItem(
                      icon: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Image.asset(
                            'assets/icon_transaction.png',
                            width: 17,
                            color: pageProvider.currentIndex == 3 ? secondaryColor : secondaryTextColor,)
                      ),
                      label: 'Transaksi'
                  ),
                ],
              selectedItemColor: secondaryColor,
              selectedFontSize: 14,
              unselectedFontSize: 13,
              selectedLabelStyle: labelTextStyle,
              unselectedLabelStyle: secondaryTextStyle,
            ),
          ),
      );
    }

    Widget body() {
      switch(pageProvider.currentIndex) {
        case 0:
          return HomePage();
        case 1:
          return user!=null ? ChatPage(product: context.read<MessageProvider>().linkedProduct,) : DirectToAuthPage();
        case 2:
          return user!=null ? CartPage() : DirectToAuthPage();
        case 3:
          return user!=null ? TransactionPage() : DirectToAuthPage();
        default:
          return HomePage();
      }
    }

    return Scaffold(
      bottomNavigationBar: customBottomNav(),
      body: body(),
    );
  }
}