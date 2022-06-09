// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/views/widgets/product_card.dart';

import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Widget search() {
      return Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 40,
        padding: EdgeInsets.symmetric(
            horizontal: 16
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow> [
              BoxShadow(color: Color(0xff2895BD).withOpacity(0.3), blurRadius: 15.0),
            ]
        ),
        child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: primaryTextStyle,
                  controller: searchController,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Cari nama produk',
                      hintStyle: secondaryTextStyle
                  ),
                ),
              ),
              SizedBox(width: 16,),
              Icon(Icons.search, color: secondaryTextColor,),
            ]
        ),
      );
    }

    Widget headerContent() {
      return Container(
        margin: EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Halo John!',
                      style: whiteTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: semiBold
                      )
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Selamat datang di Budi Beras!',
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: Colors.white.withOpacity(0.25),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_filled, color: secondaryColor,),
                          SizedBox(width: 10,),
                          Text(
                            'Buka: 07.00 - 17.00',
                            style: whiteTextStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage('assets/profile_image.png')),
              ),
            )
          ],
        ),
      );
    }

    Widget header() {
      return Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            color: primaryColor,
          ),
          headerContent(),
          Positioned(
            top: 140,
            left: 20,
            child: search()
          ),
        ],
      );
    }

    Widget category() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Belanja berdasarkan Kategori',
              style: primaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12, left: 20),
            child: Consumer<CategoryProvider>(
              builder: (context, data, child) {
                return SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: data.categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        margin: EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: outlinedBtnColor,
                          ),
                          color: transparentColor,
                        ),
                        child: Center(
                          child: Text(
                            data.categories[index].categoryName,
                            style: greyTextStyle.copyWith(
                              fontSize: 13,
                              fontWeight: medium,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ),
        ],
      );
    }

    Widget productTitle() {
      return Padding(
        padding: const EdgeInsets.only(
          top: 22,
          left: 20,
        ),
        child: Text(
          'Daftar Semua Produk',
          style: primaryTextStyle.copyWith(
            fontWeight: semiBold,
          ),
        ),
      );
    }

    Widget product() {
      return Consumer<ProductProvider>(
        builder: (context, data, child) {
          return GridView(
            padding: EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: data.products.map(
                (product) => ProductCard(product: product)
            ).toList(),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          );
        }
      );
    }
    
    return ListView(
      children: [
        SafeArea(child: header()),
        category(),
        productTitle(),
        product(),
      ],
    );
  }
}
