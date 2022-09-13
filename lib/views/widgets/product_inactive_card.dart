import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/image_builder.dart';

import '../../models/product_model.dart';

import '../../theme.dart';
import '../detail_product_page.dart';

class InactiveProductCard extends StatelessWidget {
  final ProductModel product;

  const InactiveProductCard({
    Key? key,
    required this.product
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');

    Widget image() {
      return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: product.galleries.isNotEmpty
              ? ImageBuilderWidgets().imageFromNetwork(
              imageUrl: product.galleries[0].url.toString(),
              width: 100,
              height: 100,
              sizeIconError: 100
          ) : ImageBuilderWidgets().blankImage(sizeIcon: 100)
      );
    }

    Widget inactiveLabel() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color(0xffffdeeb).withOpacity(0.5),
        ),
        child: Text(
            'Tidak aktif',
            style: alertTextStyle.copyWith(fontSize: 12)
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => DetailProductPage(product: product))
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: secondaryTextColor.withOpacity(0.8), width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              inactiveLabel(),
              const SizedBox(height: 8,),
              Center(
                child: image()
              ),
              const SizedBox(height: 16,),
              Text(
                product.category.categoryName,
                style: secondaryTextStyle.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.name,
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4,),
              Text(
                'Rp ${formatter.format(product.price)}',
                style: priceTextStyle.copyWith(
                  fontWeight: semiBold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
