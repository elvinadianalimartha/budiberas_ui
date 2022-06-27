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

  ChatBubble({
    this.isSender = false,
    this.text = '',
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    
    Widget productPreview(){
      return Container(
        width: 240,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? fourthColor.withOpacity(0.8) : formColor,
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
            SizedBox(height: 12,),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xffE6F6F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: secondaryColor),
                ),
              ),
              onPressed: () {

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.add_circle, size: 22, color: primaryColor,),
                  SizedBox(width: 6,),
                  Flexible(
                    child: Text(
                      'Masukkan ke Keranjang',
                      style: orderNotesTextStyle,
                    ),
                  ),
                ],
              ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSender ? fourthColor.withOpacity(0.8) : formColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isSender ? 12 : 0),
                      topRight: Radius.circular(isSender ? 0 : 12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  ),
                  child: Text(
                    text,
                    style: primaryTextStyle,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
