import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_budiberas_9701/models/transaction_model.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/image_builder.dart';
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              formattedDate + ' | ' + transactions.checkoutTime,
              style: primaryTextStyle.copyWith(fontSize: 12),
            ),
          ),
          const SizedBox(width: 12,),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: fourthColor.withOpacity(0.5),
            ),
            child: Text(
              transactions.transactionStatus,
              style: priceTextStyle.copyWith(fontSize: 12),
            ),
          )
        ],
      );
    }

    Widget content() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
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

    Widget footer() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: Rp ' + formatter.format(transactions.totalPrice),
            style: priceTextStyle,
          ),
          Text(
            'Metode: ' + transactions.shippingType,
            style: primaryTextStyle,
          )
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
