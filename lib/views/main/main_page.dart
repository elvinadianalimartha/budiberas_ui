import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/views/main/transaction_page.dart';
import 'package:skripsi_budiberas_9701/providers/page_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';

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
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Image.asset(
                            'assets/icon_home.png',
                            width: 21,
                            color: pageProvider.currentIndex == 0 ? secondaryColor : secondaryTextColor,
                          )
                      ),
                      label: 'Beranda'
                  ),
                  BottomNavigationBarItem(
                      icon: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Image.asset(
                            'assets/icon_chat.png',
                            width: 22,
                            color: pageProvider.currentIndex == 1 ? secondaryColor : secondaryTextColor,
                          )
                      ),
                      label: 'Obrolan'
                  ),
                  BottomNavigationBarItem(
                      icon: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Image.asset(
                            'assets/icon_cart.png',
                            width: 20,
                            color: pageProvider.currentIndex == 2 ? secondaryColor : secondaryTextColor,)
                      ),
                      label: 'Keranjang'
                  ),
                  BottomNavigationBarItem(
                      icon: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Image.asset(
                            'assets/icon_transaction.png',
                            width: 20,
                            color: pageProvider.currentIndex == 3 ? secondaryColor : secondaryTextColor,)
                      ),
                      label: 'Transaksi'
                  ),
                ],
              selectedItemColor: secondaryColor,
              selectedFontSize: 16,
              unselectedFontSize: 14,
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
          return ChatPage();
        case 2:
          return CartPage();
        case 3:
          return TransactionPage();
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