import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/models/transaction_model.dart';
import 'package:skripsi_budiberas_9701/providers/transaction_provider.dart';
import 'package:skripsi_budiberas_9701/views/pickup_confirmation_page.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/image_builder.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/trans_update_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/transaction_status_label.dart';
import 'package:skripsi_budiberas_9701/views/widgets/transaction_detail_delivery.dart';

import '../../theme.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transactions;

  const TransactionCard({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(transactions.checkoutDate);

    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  formattedDate + ' | ' + transactions.checkoutTime,
                  style: secondaryTextStyle.copyWith(fontSize: 11),
                ),
              ),
              const SizedBox(width: 12,),
              TransactionStatusLabel().labellingStatus(transactions.transactionStatus),
            ],
          ),
          const SizedBox(height: 4,),
          Text(
            transactions.invoiceCode,
            style: primaryTextStyle.copyWith(fontSize: 12),
          ),
          Text(
            'Metode: ' + transactions.shippingType,
            style: greyTextStyle.copyWith(fontSize: 12),
          ),
          const Divider(thickness: 1,),
        ],
      );
    }

    Widget content() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: transactions.details[0].product.galleries.isNotEmpty
                        ? ImageBuilderWidgets().imageFromNetwork(
                        imageUrl: transactions.details[0].product.galleries[0]
                            .url!,
                        width: 60,
                        height: 60,
                        sizeIconError: 60
                    )
                        : ImageBuilderWidgets().blankImage(sizeIcon: 60)
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactions.details[0].product.productName,
                        style: primaryTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4,),
                      Text(
                        '${transactions.details[0].quantity} barang',
                        style: greyTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8,),
                    ],
                  ),
                ),
              ],
            ),
            transactions.countRemainingDetails == 0
            ? const SizedBox()
            : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '+ ' + transactions.countRemainingDetails.toString() +
                    ' produk lainnya',
                style: primaryTextStyle,
              ),
            )
          ],
        ),
      );
    }

    handleUpdateStatusToDone({
      required String status,
    }) async {
      if(await context.read<TransactionProvider>().updateStatusTransaction(id: transactions.id, newStatus: status)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Transaksi berhasil diselesaikan'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Transaksi gagal diselesaikan'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    transUpdateBtn(String status) {
      switch (status.toLowerCase()) {
        case 'arrived': //pesan antar tiba di tujuan
          return TransUpdateBtn(
            text: 'Selesai',
            onClick: () {
              //updateStatus to done
              handleUpdateStatusToDone(status: 'done');
            },
          );
        case 'ready to take':
          return TransUpdateBtn(
            text: 'Ambil Pesanan',
            onClick: () {
              //navigator push ke page konfirmasi (isi kode pickup)
              Navigator.push(context, MaterialPageRoute(builder: (context) => PickupConfirmationPage(
                transactionId: transactions.id,
                invoiceCode: transactions.invoiceCode,
              )));
            },
          );
        default:
          return const SizedBox();
      }
    }

    Widget footer() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: Rp ' + formatter.format(transactions.totalPrice),
            style: priceTextStyle,
          ),
          transUpdateBtn(transactions.transactionStatus),
        ],
      );
    }

    return InkWell(
      onTap: () {
        if(transactions.shippingType.toLowerCase() == 'pesan antar') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailDelivery(transactions: transactions,)));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: 20,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: secondaryTextColor.withOpacity(0.8), width: 0.5),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            content(),
            footer(),
          ],
        ),
      ),
    );
  }
}
