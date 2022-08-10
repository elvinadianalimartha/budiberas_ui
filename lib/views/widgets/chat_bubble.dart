// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/image_builder.dart';

import '../../models/product_model.dart';
import '../../theme.dart';

class ChatBubble extends StatelessWidget {

  final String text;
  final bool isSender; //if true, berarti pengirim. if false penerima
  final ProductModel? product;
  final DateTime createdAt;

  ChatBubble({
    this.isSender = false,
    this.text = '',
    this.product,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm', 'id').format(createdAt);
    
    Widget productPreview(){
      return Container(
        width: 240,
        margin: EdgeInsets.only(bottom: 3),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? fourthColor.withOpacity(0.5) : formColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 12 : 0),
            topRight: Radius.circular(isSender ? 0 : 12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: product!.galleries.isNotEmpty
                    ? ImageBuilderWidgets().imageFromNetwork(
                        imageUrl: product!.galleries[0].url.toString(),
                        width: 60,
                        height: 60,
                        sizeIconError: 60
                      )
                    : ImageBuilderWidgets().blankImage(sizeIcon: 60),
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product!.name,
                        style: primaryTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Rp ${formatter.format(product!.price)}',
                        style: priceTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    //bagian chat bubble
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          product is UninitializedProductModel ? SizedBox() : productPreview(),
          Row(
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6, //spy ukuran bubblenya max cm 60% dr ukuran layar
                  ),
                  padding: EdgeInsets.only(
                    right: 16,
                    left: 16,
                    top: 12,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSender ? fourthColor.withOpacity(0.8) : Color(0xffEAEAF1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isSender ? 12 : 0),
                      topRight: Radius.circular(isSender ? 0 : 12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: primaryTextStyle,
                      ),
                      SizedBox(height: 6,),
                      Text(
                        formattedDate,
                        style: isSender ? priceTextStyle.copyWith(fontSize: 11) : secondaryTextStyle.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
