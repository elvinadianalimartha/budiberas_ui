import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';

import '../models/product_model.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

class DetailProductPage extends StatelessWidget {
  final ProductModel product;

  const DetailProductPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');

    Widget header() {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: fourthColor,
                    ),
                    child: const Icon(Icons.chevron_left),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                InkWell(
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: fourthColor,
                    ),
                    child: Image.asset('assets/icon_cart.png', width: 24, color: secondaryColor,)
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                )
              ],
            ),
          ),
          CarouselSlider(
            items: product.galleries.map(
                  (image) => Image.network(
                    constants.urlPhoto + image.url.toString(),
                    //width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.cover,
                  )
            ).toList(),
            options: CarouselOptions(
              initialPage: 0,
              onPageChanged: (a, reason) {

              }
            ),
          )
        ],
      );
    }

    Widget content() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //NOTE: product name
              Text(
                product.name,
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4,),
              Text(
                product.category.categoryName,
                style: secondaryTextStyle.copyWith(
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4,),
              Text(
                'Rp ${formatter.format(product.price)}',
                style: priceTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20,),
              Text(
                'Deskripsi',
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 4,),
              Text(
                product.description,
                style: greyTextStyle,
              )
            ],
          ),
        ),
      );
    }

    Widget actionButton() {
      return Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => DetailChatPage(widget.product))
                    // );
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      border: Border.all(color: btnColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.chat, color: btnColor),
                  ),
                ),
                const SizedBox(width: 16,),
                const Expanded(
                  child: DoneButton(
                    text: 'Masukkan ke Keranjang',
                  ),
                )
              ],
            ),
        ),
        );
    }

    return Scaffold(
      backgroundColor: formColor,
      body: Column(
        children: [
          Flexible(
            child: ListView(
              children: [
                header(),
                content(),
              ],
            ),
          ),
          actionButton(),
        ],
      ),
    );
  }
}
