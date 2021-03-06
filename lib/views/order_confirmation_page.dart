import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/order_confirmation_provider.dart';
import 'package:skripsi_budiberas_9701/providers/shop_info_provider.dart';
import 'package:skripsi_budiberas_9701/providers/user_detail_provider.dart';
import 'package:skripsi_budiberas_9701/views/payment_method_page.dart';
import 'package:skripsi_budiberas_9701/views/widgets/address_page.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/btn_with_icon.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/cancel_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/loading_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/selected_cart_card.dart';

import '../models/cart_model.dart';
import '../theme.dart';

class OrderConfirmationPage extends StatefulWidget {

  const OrderConfirmationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  var formatter = NumberFormat.decimalPattern('id');
  String shippingType = 'Pesan Antar';

  late ShopInfoProvider shopInfoProvider;
  late UserDetailProvider userDetailProvider;
  late OrderConfirmationProvider orderConfirmationProvider;
  bool isLoadingCheckout = false;

  @override
  void initState() {
    super.initState();
    shopInfoProvider = Provider.of<ShopInfoProvider>(context, listen: false);
    userDetailProvider = Provider.of<UserDetailProvider>(context, listen: false);
    orderConfirmationProvider = Provider.of<OrderConfirmationProvider>(context, listen: false);
    getInit();
  }

  getInit() async {
    await Future.wait([
      //get shop lat long
      shopInfoProvider.getShopInfo(),
      //get biaya per km
      shopInfoProvider.getShippingRates(),
      userDetailProvider.getDefaultDetailUser(),
      orderConfirmationProvider.getSelectedCarts(),
    ]);
  }

  @override
  Widget build(BuildContext context) {

    //==================== REUSABLE WIDGET FOR THIS PAGE =======================
    Widget changeBtn({
      required VoidCallback onTap,
      required String textData,
    }) {
      return InkWell(
        onTap: onTap,
        splashColor: fourthColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: thirdColor,
            ),
          ),
          child: Text(
            textData,
            style: priceTextStyle,
          ),
        ),
      );
    }

    Widget shippingTypeField({
      required Widget iconData,
      required String typeName,
      required List<Widget> listNotes,
      required VoidCallback onTap,
    }) {
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 16, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: thirdColor,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: iconData,
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Text(
                    typeName,
                    style: primaryTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                changeBtn(
                  onTap: onTap,
                  textData: 'Ganti metode'
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: listNotes,
              ),
            ),
          ],
        ),
      );
    }

    Future<void> dialogChangePickupMethod({
      required String imagePath,
      required String question,
      required TextSpan subtitles,
      required VoidCallback onCancelClick,
      required VoidCallback onDoneClick,
      required String textOnDoneBtn,
    }) async{
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
                  Image.asset(imagePath, width: 90,),
                  const SizedBox(height: 12,),
                  Text(
                    question,
                    style: primaryTextStyle.copyWith(fontWeight: semiBold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12,),
                  RichText(
                    textAlign: TextAlign.center,
                    text: subtitles,
                  ),
                  const SizedBox(height: 20,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CancelButton(
                          onClick: onCancelClick,
                          text: 'Batal',
                          fontSize: 14,
                        ),
                        const SizedBox(width: 16,),
                        DoneButton(
                          onClick: onDoneClick,
                          text: textOnDoneBtn,
                          fontSize: 14,
                        ),
                      ]
                  )
                ],
              ),
            ),
          )
      );
    }
    //==========================================================================

    Widget addressField() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              horizontalTitleGap: 10,
              contentPadding: const EdgeInsets.all(0),
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: thirdColor,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.location_on_rounded, size: 20, color: Colors.white,),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Alamat Pengiriman',
                  style: primaryTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: semiBold,
                  ),
                ),
              ),
              subtitle: Consumer<UserDetailProvider>(
                  builder: (context, aaaa, child) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userDetailProvider.defaultUserDetail!.addressOwner,
                            style: primaryTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            userDetailProvider.defaultUserDetail!.phoneNumber,
                            style: greyTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            userDetailProvider.defaultUserDetail!.address,
                            style: greyTextStyle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    );
                  }
              ),
              trailing: changeBtn(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressPage(isFromConfirmationPage: true)));
                  },
                  textData: 'Ganti alamat'
              ),
            ),
          ],
        ),
      );
    }

    Widget selfPickup() {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: shippingTypeField(
          iconData: const Icon(Icons.directions_walk, size: 20, color: Colors.white,),
          typeName: 'Ambil Mandiri',
          listNotes: [
            Text(
              'Ambil pesanan Anda di:',
              style: greyTextStyle,
              maxLines: null,
            ),
            Text(
              'Jalan Parangtritis no.76, Mantrijeron, Yogyakarta (Seberang Pasar Prawirotaman)',
              style: primaryTextStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          onTap: () {
            dialogChangePickupMethod(
                imagePath: 'assets/delivery_img.png',
                question: 'Ganti metode jadi pesan antar?',
                subtitles: TextSpan(
                  text: 'Cukup duduk manis, pesanan Anda siap diantar sampai ke alamat tujuan ????',
                  style: greyTextStyle,
                ),
                onDoneClick: () {
                  setState(() {
                    shippingType = 'Pesan Antar';
                  });
                  Navigator.pop(context);
                },
                textOnDoneBtn: 'Ya, pesan antar',
                onCancelClick: () { 
                  Navigator.pop(context);
                }
            );
          },
        ),
      );
    }

    Widget delivery() {
      return Consumer2<ShopInfoProvider, UserDetailProvider>(
        builder: (context, shopInfoProv, userDetailProv, child) {
          return shippingTypeField(
            iconData: Image.asset('assets/delivery_icon.png', width: 18, color: Colors.white,),
            typeName: 'Pesan Antar',
            listNotes: [
              Text(
                'Jarak antar: ${shopInfoProv.countDistance(
                    destinationLat: userDetailProv.defaultUserDetail!.latitude,
                    destinationLong: userDetailProv.defaultUserDetail!.longitude,
                )} km',
                style: greyTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '+Ongkir Rp ${formatter.format(shopInfoProv.countShippingPrice())}',
                style: greyTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4,),
              Text(
                'Baca S & K untuk dapat gratis ongkir', //nanti ini pakai rich text
                style: primaryTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            onTap: () {
              dialogChangePickupMethod(
                  imagePath: 'assets/self_pickup.png',
                  question: 'Ganti metode jadi ambil mandiri?',
                  subtitles: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Dengan metode ini, Anda ',
                            style: greyTextStyle
                        ),
                        TextSpan(
                          text: 'tidak perlu bayar ongkir & ambil pesanan Anda sendiri ',
                          style: orderNotesTextStyle.copyWith(
                            fontWeight: semiBold,
                          ),
                        ),
                        TextSpan(
                            text: 'di Budi Beras ????',
                            style: greyTextStyle
                        ),
                      ]
                  ),
                  onDoneClick: () {
                    setState(() {
                      shippingType = 'Ambil Mandiri';
                    });
                    Navigator.pop(context);
                  },
                  textOnDoneBtn: 'Ya, ambil mandiri',
                  onCancelClick: () {
                    Navigator.pop(context);
                  }
              );
            },
          );
        }
      );
    }

    Widget listOrder() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Pesanan',
              style: primaryTextStyle.copyWith(
                fontSize: 15,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 20,),
            Consumer<OrderConfirmationProvider>(
              builder: (context, orderConfirmProvider, child) {
                List<CartModel> selectedCarts = orderConfirmProvider.selectedCartsFromServer;
                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: selectedCarts.length,
                  itemBuilder: (context, index) {
                    return SelectedCartCard(selectedCart: selectedCarts[index]);
                  }
                );
              }
            )
          ],
        ),
      );
    }

    Widget billingDetail() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Consumer2<OrderConfirmationProvider, ShopInfoProvider>(
          builder: (context, orderConfirmProv, shopInfoProv, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rincian Pembayaran',
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Harga',
                      style: greyTextStyle,
                    ),
                    Text(
                      'Rp ${formatter.format(orderConfirmProv.confirmCountTotalPrice())}',
                      style: greyTextStyle,
                    )
                  ],
                ),
                const SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Biaya Pengiriman',
                      style: greyTextStyle,
                    ),
                    Text(
                      shippingType == 'Pesan Antar'
                          ? 'Rp ${formatter.format(shopInfoProv.countShippingPrice())}'
                          : 'Rp 0',
                      style: greyTextStyle,
                    )
                  ],
                ),
                const SizedBox(height: 8,),
                const Divider(height: 2,),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pembayaran',
                      style: primaryTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Rp ${formatter.format(shopInfoProv.countTotalBill(shippingType))}',
                      style: priceTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        ),
      );
    }

    Widget loadingProgress() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    handleCheckout() async{
      setState(() {
        isLoadingCheckout = true;
      });

      if(await orderConfirmationProvider.checkout(
        totalPrice: double.parse(shopInfoProvider.countTotalBill(shippingType).toString()),
        shippingRate: shippingType == 'Pesan Antar' ? double.parse(shopInfoProvider.countShippingPrice().toString()) : 0,
        shippingType: shippingType,
        orderReceiver: shippingType == 'Pesan Antar' ? userDetailProvider.defaultUserDetail!.addressOwner : null,
        phoneNumber: shippingType == 'Pesan Antar' ? userDetailProvider.defaultUserDetail!.phoneNumber : null,
        address: shippingType == 'Pesan Antar' ? userDetailProvider.defaultUserDetail!.address : null,
        detailAddress: shippingType == 'Pesan Antar' ? userDetailProvider.defaultUserDetail!.addressNotes : null,
      )) {
        String transToken = orderConfirmationProvider.snapToken;
        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentMethodPage(
            transactionToken: transToken,
        )));
      }

      setState(() {
        isLoadingCheckout = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Konfirmasi Pesanan',
          style: whiteTextStyle.copyWith(
            fontSize: 16,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: Consumer2<UserDetailProvider, OrderConfirmationProvider>(
        builder: (context, userDetailProv, orderConfirmProv, child) {
          if(userDetailProv.defaultUserDetail == null || shopInfoProvider.shopInfo == null || orderConfirmProv.loadingGetData) {
            return loadingProgress();
          } else {
            return ListView(
              children: [
                shippingType == 'Pesan Antar'
                 ? Column(
                    children: [
                      addressField(),
                      const Divider(thickness: 2,),
                      delivery(),
                    ],
                  )
                 : selfPickup(),
                const Divider(thickness: 2,),
                listOrder(),
                const Divider(thickness: 2,),
                billingDetail(),
              ],
            );
          }
        }
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 50,
          child: isLoadingCheckout
            ? const LoadingButton()
            : BtnWithIcon(
              text: 'Bayar',
              onClick: () {
                handleCheckout();
              },
            ),
        ),
      ),
    );
  }
}