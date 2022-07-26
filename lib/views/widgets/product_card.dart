import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/cart_provider.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/direct_to_auth_dialog.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/succeed_dialog.dart';

import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
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

    Future<void> addToCartSucceed() async{
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
          return SucceedDialogWidget(text: '${product.name} berhasil ditambahkan ke keranjang',);
        }
      );
    }

    handleAddToCart({
      required String token,
      required int productId,
    }) async {
      if(await CartProvider().addToCart(token: token, productId: productId)) {
        addToCartSucceed();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Produk gagal ditambahkan'),
            backgroundColor: alertColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    Future<void> redirectToAuthDialog() async {
      return showDialog(
          context: context,
          builder: (BuildContext context) => const DirectToAuthDialog()
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
                style: secondaryTextStyle.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4,),
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
              const Spacer(),
              product.stockStatus.toLowerCase() == 'tidak aktif'
              ? const SizedBox()
              : Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return InkWell(
                    splashColor: btnColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      authProvider.user != null
                        ? handleAddToCart(productId: product.id, token: authProvider.user!.token!)
                        : redirectToAuthDialog(); //NOTE: jika user blm login (user model masih null), maka di-direct ke auth dulu
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
                  );
                }
              ),
              const SizedBox(height: 8,),
            ],
          ),
        ),
      ),
    );
  }
}
