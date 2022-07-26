import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/cart_model.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

import '../../theme.dart';

class InactiveCartCard extends StatelessWidget {
  late final CartModel cart;

  InactiveCartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');

    Widget grayscaleImage() {
      return Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: cart.product.galleries.isNotEmpty
                  ? Image.network(
                constants.urlPhoto + cart.product.galleries[0].url.toString(),
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withOpacity(0.5),
            ),
            width: 70,
            height: 70,
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          grayscaleImage(),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.product.name,
                  style: greyTextStyle.copyWith(
                    fontWeight: semiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4,),
                Text(
                  'Rp ${formatter.format(cart.product.price)}',
                  style: secondaryTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
