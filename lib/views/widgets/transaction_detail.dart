import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/shop_info_provider.dart';
import 'package:skripsi_budiberas_9701/providers/transaction_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/app_bar.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/image_builder.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/transaction_detail_widget.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/transaction_status_label.dart';

import '../../models/transaction_model.dart';

class TransactionDetail extends StatefulWidget {
  final TransactionModel transactions;

  const TransactionDetail({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    String transactionStatus = widget.transactions.transactionStatus.toLowerCase();

    if(widget.transactions.shippingType.toLowerCase() == 'ambil mandiri' && (transactionStatus != 'done' && transactionStatus != 'cancelled')) {
      await Provider.of<ShopInfoProvider>(context, listen: false).getShopInfo();
    }
    await Provider.of<TransactionProvider>(context, listen: false).pusherTransactionHistory();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    String formattedPaymentMethod = widget.transactions.paymentMethod.replaceAll('_', ' ').toUpperCase();

    double totalPriceProduct = widget.transactions.totalPrice - widget.transactions.shippingRate;
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(widget.transactions.checkoutDate);

    Widget header() {
      return Consumer<TransactionProvider>(
        builder: (context, transProv, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.transactions.invoiceCode,
                  style: primaryTextStyle.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 5,),
                Text(
                  'Tanggal pembelian: ' + formattedDate + ' | ' + widget.transactions.checkoutTime,
                  style: greyTextStyle.copyWith(fontSize: 13),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Divider(thickness: 1,),
                ),
                //jika mau connect ke pusher, harus pakai consumer (atau set state) spy bisa langsung terubah datanya
                TransactionStatusLabel().statusDetail(
                    transProv.transactions.where((e) => e.id == widget.transactions.id).first.transactionStatus
                ),
              ],
            ),
          );
        }
      );
    }

    Widget deliveryDetail() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan dikirimkan kepada: ',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            const SizedBox(height: 4,),
            Text(
              widget.transactions.orderReceiver!,
              style: primaryTextStyle.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 4,),
            Text(
              widget.transactions.phoneNumber!,
              style: greyTextStyle.copyWith(fontSize: 13)
            ),
            const SizedBox(height: 4,),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.transactions.address,
                      style: greyTextStyle.copyWith(fontSize: 13),
                    ),
                    widget.transactions.detailAddress != '' && widget.transactions.detailAddress != null
                      ? TextSpan(
                        text: ' (${widget.transactions.detailAddress})',
                        style: greyTextStyle.copyWith(fontSize: 13),
                      )
                      : const TextSpan()
                  ]
              )
            )
          ],
        ),
      );
    }

    Widget pickupDetail() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan diambil di: ',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            const SizedBox(height: 4,),
            Consumer<ShopInfoProvider>(
              builder: (context, shopInfoProv, child) {
                return RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                          text: shopInfoProv.shopInfo!.shopAddress,
                          style: primaryTextStyle,
                        ),
                        shopInfoProv.shopInfo!.addressNotes != '' && shopInfoProv.shopInfo!.addressNotes != null
                            ? TextSpan(
                          text: ' (${shopInfoProv.shopInfo!.addressNotes})',
                          style: primaryTextStyle,
                        )
                            : const TextSpan()
                      ]
                  )
                );
              }
            )
          ],
        ),
      );
    }

    Widget notePickupWhenDone() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Text(
          'Pesanan sudah diambil di toko 👍',
          style: primaryTextStyle,
        ),
      );
    }

    Widget orderList() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Daftar Pesanan',
                style: primaryTextStyle.copyWith(fontWeight: semiBold),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(), //disable scrolling
              padding: const EdgeInsets.only(bottom: 0),
              shrinkWrap: true,
              itemCount: widget.transactions.details.length,
              itemBuilder: (context, index) {
                return OrderDetailWidget(
                  photo: widget.transactions.details[index].product.galleries.isNotEmpty
                      ? ImageBuilderWidgets().imageFromNetwork(
                      imageUrl: widget.transactions.details[index].product.galleries[0].url!,
                      width: 60,
                      height: 60,
                      sizeIconError: 60
                  )
                      : ImageBuilderWidgets().blankImage(sizeIcon: 60),
                  productName: widget.transactions.details[index].product.productName,
                  quantity: '${widget.transactions.details[index].quantity} barang',
                  subtotal: 'Rp ' + formatter.format(widget.transactions.details[index].subtotal),
                  orderNotes: widget.transactions.details[index].orderNotes,
                );
              }
            )
          ],
        ),
      );
    }

    Widget billing() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8,),
            BillingDetailWidget(
                totalPrice: 'Rp ' + formatter.format(totalPriceProduct),
                shippingRate: 'Rp ' + formatter.format(widget.transactions.shippingRate)
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(thickness: 1,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Pembayaran',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
                Text(
                  'Rp ' + formatter.format(widget.transactions.totalPrice),
                  style: priceTextStyle.copyWith(fontWeight: semiBold),
                )
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Metode Bayar',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
                const SizedBox(width: 20,),
                Flexible(
                  child: Text(
                    widget.transactions.bankName == null
                      ? formattedPaymentMethod
                      : formattedPaymentMethod + ' ' + widget.transactions.bankName!.toUpperCase(),
                    style: orderNotesTextStyle.copyWith(fontWeight: semiBold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8,),
            widget.transactions.vaNumber != null
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nomor VA',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
                const SizedBox(width: 20,),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: formColor,
                          border: Border.all(
                            color: const Color(0xffEAEAF1)
                          )
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          widget.transactions.vaNumber!,
                          style: orderNotesTextStyle.copyWith(fontWeight: semiBold, letterSpacing: 1),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 4,),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(8),
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.transactions.vaNumber!))
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: const Text('No. virtual account berhasil disalin'),
                                backgroundColor: secondaryColor,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          });
                        },
                        child: Text(
                          'Salin',
                          style: whiteTextStyle.copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
            : const SizedBox(),
          ],
        ),
      );
    }

    handleUpdateStatusToDone() async {
      if(await context.read<TransactionProvider>().updateStatusTransaction(id: widget.transactions.id, newStatus: 'done')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Transaksi berhasil diselesaikan'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Transaksi gagal diselesaikan'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    Widget changeStatusBtn() {
      return Container(
       decoration: BoxDecoration(
         color: Colors.white,
            boxShadow: <BoxShadow> [
              BoxShadow(color: secondaryTextColor.withOpacity(0.2), blurRadius: 20.0),
            ]
        ),
        padding: const EdgeInsets.all(20),
        child: DoneButton(
          text: 'Selesaikan Pesanan',
          onClick: () {
            handleUpdateStatusToDone();
          },
        )
      );
    }

    Widget content() {
      String transactionStatus = widget.transactions.transactionStatus.toLowerCase();
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const Divider(thickness: 2,),
            widget.transactions.shippingType.toLowerCase() == 'pesan antar'
                ? deliveryDetail()
                : transactionStatus == 'done' ? notePickupWhenDone() : transactionStatus != 'cancelled' ? pickupDetail() : SizedBox(),
            const Divider(thickness: 2,),
            orderList(),
            const Divider(thickness: 2,),
            billing(),
            const SizedBox(height: 20,),
          ],
        ),
      );
    }

    Widget loadingWidget() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Consumer<ShopInfoProvider>(
      builder: (context, shopInfoProv, child) {
        return Scaffold(
            appBar: customAppBar(text: 'Detail Riwayat Transaksi'),
            body: shopInfoProv.loadingGetShopInfo ? loadingWidget() : content(),
            bottomNavigationBar: widget.transactions.transactionStatus.toLowerCase() == 'arrived' ? changeStatusBtn() : const SizedBox()
        );
      }
    );
  }
}
