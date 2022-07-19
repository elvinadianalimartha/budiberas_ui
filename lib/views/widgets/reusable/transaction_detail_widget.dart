import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class OrderDetailWidget extends StatelessWidget {
  final Widget photo;
  final String productName;
  final String quantity;
  final String subtotal;
  final String? orderNotes;

  const OrderDetailWidget ({
    Key? key,
    required this.photo,
    required this.productName,
    required this.quantity,
    required this.subtotal,
    this.orderNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: photo,
          ),
          const SizedBox(width: 20,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4,),
                Row(
                  children: [
                    Text(
                      quantity,
                      style: greyTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 5,),
                    Icon(Icons.circle, size: 5, color: secondaryTextColor,),
                    const SizedBox(width: 5,),
                    Text(
                      subtotal,
                      style: priceTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                orderNotes != null
                    ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: formColor,
                        border: Border(
                          left: BorderSide(width: 4, color: fourthColor),
                          bottom: BorderSide(color: secondaryTextColor, width: 0.3),
                          right: BorderSide(color: secondaryTextColor, width: 0.3),
                          top: BorderSide(color: secondaryTextColor, width: 0.3),
                        ),
                      ),
                      child: Text(
                        'NB: ' + orderNotes!,
                        style: greyTextStyle.copyWith(fontWeight: medium, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BillingDetailWidget extends StatelessWidget {
  final String totalPrice;
  final String shippingRate;

  const BillingDetailWidget({
    Key? key,
    required this.totalPrice,
    required this.shippingRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            totalPrice,
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
          shippingRate,
          style: greyTextStyle,
        )
       ],
      ),
    ]);
  }
}


