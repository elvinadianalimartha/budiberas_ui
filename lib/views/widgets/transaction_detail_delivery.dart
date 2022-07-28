import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/transaction_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/app_bar.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/image_builder.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/transaction_detail_widget.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/transaction_status_label.dart';

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

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
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
        builder: (context, data, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
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
                    data.transactions.where((e) => e.id == widget.transactions.id).first.transactionStatus
                ),
              ],
            ),
          );
        }
      );
    }

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
              widget.transactions.orderReceiver!,
              style: primaryTextStyle.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 4,),
            Text(
              widget.transactions.phoneNumber!,
              style: greyTextStyle.copyWith(fontSize: 13)
            ),
            const SizedBox(height: 4,),
            Text(
                widget.transactions.address!,
              style: greyTextStyle.copyWith(fontSize: 13)
            ),
            widget.transactions.detailAddress != null
              ? Text(
                  '(${widget.transactions.detailAddress!})',
                  style: greyTextStyle.copyWith(fontSize: 13)
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
                  child: Text(
                    widget.transactions.vaNumber!,
                    style: orderNotesTextStyle.copyWith(fontWeight: semiBold, letterSpacing: 1),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            )
            : const SizedBox(),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Detail Riwayat Transaksi'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const Divider(thickness: 2,),
            deliveryDetail(),
            const Divider(thickness: 2,),
            orderList(),
            const Divider(thickness: 2,),
            billing(),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
