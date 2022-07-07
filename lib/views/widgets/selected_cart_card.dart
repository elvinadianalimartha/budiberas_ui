import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/cart_model.dart';
import '../../theme.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

class SelectedCartCard extends StatelessWidget {
  final CartModel selectedCart;

  const SelectedCartCard({
    Key? key,
    required this.selectedCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    var subtotal = selectedCart.product.price * selectedCart.quantity;

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: selectedCart.product.galleries.isNotEmpty
                ? Image.network(
                  constants.urlPhoto + selectedCart.product.galleries[0].url.toString(),
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Container(color: secondaryTextColor.withOpacity(0.2), child: Icon(Icons.image_not_supported_rounded, color: secondaryTextColor, size: 70,));
                  },
                )
                : Container(
                    color: secondaryTextColor.withOpacity(0.2),
                    child: Icon(Icons.image, color: secondaryTextColor, size: 70,)
                  )
          ),
          const SizedBox(width: 20,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCart.product.name,
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
                      '${selectedCart.quantity} barang',
                      style: greyTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 5,),
                    Icon(Icons.circle, size: 5, color: secondaryTextColor,),
                    const SizedBox(width: 5,),
                    Text(
                      'Rp ${formatter.format(subtotal)}',
                      style: priceTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                selectedCart.orderNotes != null
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NB: ',
                        style: greyTextStyle.copyWith(fontWeight: medium, fontSize: 13),
                      ),
                      Flexible(
                        child: Text(
                          selectedCart.orderNotes!,
                          style: greyTextStyle.copyWith(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
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
