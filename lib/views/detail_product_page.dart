import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/providers/message_provider.dart';
import 'package:skripsi_budiberas_9701/providers/product_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/direct_to_auth_dialog.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/succeed_dialog.dart';

import '../models/product_model.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

import '../providers/cart_provider.dart';
import '../providers/page_provider.dart';

class DetailProductPage extends StatefulWidget {
  final ProductModel product;

  const DetailProductPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  late ProductProvider productProvider;

  @override
  void initState() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    productProvider.disposeIndexImgValue();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('hai ini detail product page');

    var formatter = NumberFormat.decimalPattern('id');

    Widget indicator(int index) {
      return Consumer<ProductProvider>(
        builder: (context, data, child) {
          return Container(
            width: data.currentIndexImg == index ? 16 : 4,
            height: 4,
            margin: const EdgeInsets.symmetric(
              horizontal: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: data.currentIndexImg == index ? primaryColor : secondaryColor,
            ),
          );
        }
      );
    }

    Widget photoInHeader() {
      int index = -1;
      return Column(
        children: [
          Consumer<ProductProvider>(
            builder: (context, data, child) {
              return CarouselSlider(
                items: widget.product.galleries.map(
                        (image) => Image.network(
                      constants.urlPhoto + image.url.toString(),
                      height: 200,
                      width: MediaQuery.of(context).size.width/2,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Icon(Icons.image_not_supported_rounded, color: secondaryTextColor, size: 100,);
                      },
                    )
                ).toList(),
                options: CarouselOptions(
                    enableInfiniteScroll: false,
                    initialPage: 0,
                    onPageChanged: (a, reason) {
                      data.currentIndexImg = a;
                    }
                ),
              );
            }
          ),
          const SizedBox(height: 16,),
          widget.product.galleries.length > 1
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.product.galleries.map((e) {
              index++;
              return indicator(index);
            }).toList(),
          ): const SizedBox(),
        ],
      );
    }

    Widget header() {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: thirdColor.withOpacity(0.3),
                    ),
                    child: Icon(Icons.arrow_back, size: 20, color: priceColor,),
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
                      color: thirdColor.withOpacity(0.3),
                    ),
                    child: Image.asset('assets/icon_cart.png', width: 22, color: priceColor,)
                  ),
                  onTap: () {
                    context.read<PageProvider>().currentIndex = 2;
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          widget.product.galleries.isNotEmpty
            ? photoInHeader()
            : SizedBox(
                height: 250,
                child: Icon(Icons.image, color: secondaryTextColor, size: 100,)
            ),
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
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height/2,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //NOTE: product name
                Text(
                  widget.product.name,
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4,),
                Text(
                  widget.product.category.categoryName,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4,),
                Text(
                  'Rp ${formatter.format(widget.product.price)}',
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
                  widget.product.description,
                  style: greyTextStyle,
                )
              ],
            ),
          ),
        );
    }

    Future<void> addToCartSucceed() async{
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context);
            });
            return SucceedDialogWidget(text: '${widget.product.name} berhasil ditambahkan ke keranjang',);
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

    Widget actionButton() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: secondaryTextColor.withOpacity(0.5),
              blurRadius: 7.0,
              offset: const Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
              children: [
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return GestureDetector(
                      onTap: () {
                        authProvider.user != null
                        ? {
                            context.read<PageProvider>().currentIndex = 1,
                            context.read<MessageProvider>().linkedProduct = widget.product,
                            Navigator.of(context).pop(),
                          }
                        : redirectToAuthDialog();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: btnColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.chat, color: btnColor),
                      ),
                    );
                  }
                ),
                const SizedBox(width: 16,),
                Expanded(
                  child: widget.product.stockStatus.toLowerCase() == 'tidak aktif'
                  ? TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: secondaryTextColor.withOpacity(0.25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24
                        ),
                      ),
                      onPressed: () {  },
                      child: Text(
                        'Produk Tidak Aktif',
                        style: secondaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      )
                  )
                  : Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return DoneButton(
                        onClick: () {
                          authProvider.user != null
                              ? handleAddToCart(token: authProvider.user!.token!, productId: widget.product.id)
                              : redirectToAuthDialog();
                        },
                        text: 'Masukkan ke Keranjang',
                      );
                    }
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
