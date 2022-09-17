import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/cart_card.dart';
import 'package:skripsi_budiberas_9701/views/widgets/cart_card_inactive.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/btn_with_icon.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';

import '../../models/cart_model.dart';
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
    await Provider.of<CartProvider>(context, listen: false).getCartsByUser();
    Provider.of<CartProvider>(context, listen: false).initSelectedCartData();
    await Provider.of<CartProvider>(context, listen: false).pusherProductStatus();
  }

  @override
  Widget build(BuildContext context) {
    print('get data keranjang');
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

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

    updateAllCheckedVal(bool val, CartProvider cartProvider) async {
      int isSelectedInt = val? 1 : 0;
      if(await cartProvider.updateValSelectedCartAll(
          token: authProvider.user!.token!,
          isSelected: isSelectedInt)
      ) {
        return print('sukses update all is_selected');
      } else {
        return print('gagal update all is_selected');
      }
    }

    void toggleGroupCheckbox(bool? value, CartProvider cartProvider) {
      if(value == null) {
        return;
      }
      //update all
      updateAllCheckedVal(value, cartProvider);

      cartProvider.checkAll = value;
      List<CartModel> carts = cartProvider.carts.where((e) => e.product.stockStatus.toLowerCase() == 'aktif').toList();

      for (var cart in carts) {
        cart.isSelected = value; //set nilai semua isi cart jadi = value

        if(value == true) {
          if(!cartProvider.cartIdExistInSelectedCart(cart.id)) {
            cartProvider.selectCart(cart);
          }
        } else {
          cartProvider.removeFromSelectedCart(cart.id);
        }
      }
    }

    Widget buildGroupCheckbox(CartProvider cartProvider) {
      return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: primaryColor,
        title: Text('Pilih Semua', style: primaryTextStyle.copyWith(fontWeight: medium),),
        value: cartProvider.checkAll,
        onChanged: (value) {
          setState(() {
            toggleGroupCheckbox(value, cartProvider);
          });
        }
      );
    }

    Widget content(CartProvider cartProvider) {
      List<CartModel> activeProductCarts = cartProvider.carts.where((e) => e.product.stockStatus.toLowerCase() == 'aktif').toList();
      List<CartModel> inActiveProductCarts = cartProvider.carts.where((e) => e.product.stockStatus.toLowerCase() == 'tidak aktif').toList();
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildGroupCheckbox(cartProvider),
          const Divider(thickness: 3,),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: activeProductCarts.length,
                    itemBuilder: (context, index) {
                      return CartCard(cart: activeProductCarts[index]);
                    }
                  ),
                  inActiveProductCarts.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Produk sedang tidak aktif',
                            style: greyTextStyle.copyWith(fontWeight: semiBold),
                          ),
                          const SizedBox(height: 8,),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: inActiveProductCarts.length,
                              itemBuilder: (context, index) {
                                return InactiveCartCard(cart: inActiveProductCarts[index]); //card diganti abu2 semua, gak ada tombol
                              }
                          ),
                          const SizedBox(height: 8,),
                    ],
                  ),
                      )
                  : const SizedBox()
                ],
              ),
            ),
          ),
        ],
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
                    'Rp ${formatter.format(cartProvider.countTotalPrice())}',
                    style: priceTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                child: cartProvider.cartSelected.isNotEmpty
                ? BtnWithIcon(
                  text: 'Pesan Sekarang',
                  onClick: () {
                    Navigator.pushNamed(context, '/order-confirmation');
                  },
                )
                : BtnWithIcon(
                  text: 'Pesan Sekarang',
                  backgroundColor: secondaryTextColor.withOpacity(0.6),
                  onClick: (){},
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