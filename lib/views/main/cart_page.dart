import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/cart_card.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/btn_with_icon.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';

import '../../models/user_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/page_provider.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    getInit();
    super.initState();
  }

  getInit() async {
    UserModel? user = Provider.of<AuthProvider>(context, listen: false).user;
    await Provider.of<CartProvider>(context, listen: false).getCartsByUser(user!.token!);
  }

  @override
  Widget build(BuildContext context) {
    print('get data keranjang');
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    var formatter = NumberFormat.decimalPattern('id');

    PreferredSizeWidget header() {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Keranjang Belanja',
          style: whiteTextStyle.copyWith(
            fontSize: 16,
            fontWeight: semiBold,
          ),
        ),
        elevation: 0,
      );
    }

    Widget emptyCart() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_rounded,
                size: 80,
                color: secondaryColor,
              ),
              const SizedBox(height: 20,),
              Text(
                'Keranjang belanja Anda masih kosong, nih!',
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12,),
              Text(
                'Cari sembako yang Anda butuhkan dengan klik tombol di bawah ini',
                style: secondaryTextStyle.copyWith(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
              DoneButton(
                onClick: () {
                  pageProvider.currentIndex = 0;
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                text: 'Lihat Katalog Produk',
              ),
            ],
          ),
        ),
      );
    }

    Widget content(CartProvider cartProvider) {
      return ListView(
        padding: const EdgeInsets.only(top: 10),
        children: cartProvider.carts
            .map(
                (cart) => CartCard(cart: cart)
        ).toList(),
      );
    }

    Widget customBottomNav(CartProvider cartProvider){
      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: secondaryTextColor.withOpacity(0.5)),
          ),
        ),
        height: 100,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Harga : ',
                    style: primaryTextStyle.copyWith(
                        fontWeight: semiBold
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    'Rp ${formatter.format(cartProvider.totalPrice())}',
                    style: priceTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 50,
                  child: BtnWithIcon(
                    text: 'Pesan Sekarang',
                    onClick: () {

                    },
                  )
              )
            ],
          ),
        ),
      );
    }

    Widget loading() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: header(),
      body: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return SizedBox(
                child: cartProvider.loadingGetCart
                    ? loading()
                    : cartProvider.carts.isEmpty ? emptyCart() : content(cartProvider)
            );
          }
      ),
      bottomNavigationBar: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return cartProvider.loadingGetCart
                ? const SizedBox()
                : cartProvider.carts.isEmpty ? const SizedBox() : customBottomNav(cartProvider);
          }
      ),
    );
  }
}