import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/transaction_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/app_bar.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/image_builder.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/transaction_detail_widget.dart';

import '../../models/transaction_model.dart';

class TransactionDetailDelivery extends StatefulWidget {
  final TransactionModel transactions;

  const TransactionDetailDelivery({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  State<TransactionDetailDelivery> createState() => _TransactionDetailDeliveryState();
}

class _TransactionDetailDeliveryState extends State<TransactionDetailDelivery> {
  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async{
    transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    await Provider.of<TransactionProvider>(context, listen: false).getOrderReceiver(widget.transactions.userDetailId!);
  }

  @override
  void dispose() {
    super.dispose();
    //transactionProvider.disposeOrderReceiver();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');

    double totalPriceProduct = widget.transactions.totalPrice - widget.transactions.shippingRate;

    Widget deliveryDetail() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan dikirimkan kepada: ',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            const SizedBox(height: 4,),
            Text(
              transactionProvider.orderReceiver!.addressOwner,
              style: primaryTextStyle,
            ),
            const SizedBox(height: 4,),
            Text(
              transactionProvider.orderReceiver!.phoneNumber,
              style: greyTextStyle
            ),
            const SizedBox(height: 4,),
            Text(
              transactionProvider.orderReceiver!.address,
              style: greyTextStyle
            ),
            transactionProvider.orderReceiver!.addressNotes != null
              ? Text(
                  '(${transactionProvider.orderReceiver!.addressNotes})',
                  style: greyTextStyle
              )
              : const SizedBox(),
          ],
        ),
      );
    }

    Widget orderList() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              padding: const EdgeInsets.only(bottom: 0),
              shrinkWrap: true,
              itemCount: widget.transactions.details.length,
              itemBuilder: (context, index) {
                return OrderDetailWidget(
                  photo: widget.transactions.details[index].product.galleries.isNotEmpty
                      ? ImageBuilderWidgets().imageFromNetwork(
                      imageUrl: widget.transactions.details[index].product.galleries[0]
                          .url!,
                      width: 60,
                      height: 60,
                      sizeIconError: 60
                  )
                      : ImageBuilderWidgets().blankImage(sizeIcon: 60),
                  productName: widget.transactions.details[index].product.productName,
                  quantity: '${widget.transactions.details[index].quantity} barang',
                  subtotal: 'Rp ' + formatter.format(widget.transactions.details[index].subtotal)
                );
              }
            )
          ],
        ),
      );
    }

    Widget billing() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  'Metode Pembayaran',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
                Text(
                  widget.transactions.paymentMethod,
                  style: orderNotesTextStyle.copyWith(fontWeight: semiBold),
                )
              ],
            )
          ],
        ),
      );
    }

    Widget loading() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Detail Riwayat Transaksi'),
      body: Consumer<TransactionProvider>(
        builder: (context, transProv, child) {
          if(transProv.loadingReceiver == false) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                deliveryDetail(),
                const Divider(thickness: 2,),
                orderList(),
                const Divider(thickness: 2,),
                billing(),
              ],
            );
          } else {
            return loading();
          }
        }
      )
    );
  }
}
