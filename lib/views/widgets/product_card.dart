import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/product_model.dart';
import '../../theme.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

import '../detail_product_page.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    Key? key,
    required this.product
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');

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
              const SizedBox(height: 8,),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: product.galleries.isNotEmpty ?
                    Image.network(
                      constants.urlPhoto + product.galleries[0].url.toString(),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Icon(Icons.image_not_supported_rounded, color: secondaryTextColor, size: 100,);
                      },
                    ) : Icon(Icons.image, color: secondaryTextColor, size: 100,)
                ),
              ),
              const SizedBox(height: 16,),
              Text(
                product.category.categoryName,
                style: secondaryTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4,),
              Text(
                product.name,
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              InkWell(
                splashColor: btnColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  //Navigator.pushNamed(context, '/cart');
                },
                child: Ink(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: btnColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle, color: btnColor),
                      const SizedBox(width: 8,),
                      Text('Keranjang', style: yellowTextStyle.copyWith(fontWeight: medium)),
                    ],
                  )
                ),
              ),
              const SizedBox(height: 8,),
            ],
          ),
        ),
      ),
    );
  }
}
