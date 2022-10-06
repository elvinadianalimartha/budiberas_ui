import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/views/shop_by_category_page.dart';
import 'package:skripsi_budiberas_9701/views/widgets/product_card.dart';

import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../theme.dart';
import '../widgets/product_inactive_card.dart';
import '../widgets/reusable/direct_to_auth_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController(text: '');
  bool _statusFilled = false;
  late CategoryProvider categoryProvider;
  late ProductProvider productProvider;

  @override
  void initState() {
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    getInitPusher();
    super.initState();
  }

  getInitPusher() async {
    await Future.wait([
      productProvider.getProducts(),
      productProvider.pusherProductStatus()
    ]);
  }

  @override
  void dispose() {
    searchController.clear();
    productProvider.disposeSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void clearSearch() {
      searchController.clear();
      _statusFilled = false;
      productProvider.searchProduct('');
    }

    Widget search() {
      return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              style: primaryTextStyle,
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: true,
                contentPadding: const EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Cari nama produk',
                hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
                prefixIcon: Icon(Icons.search, color: secondaryTextColor, size: 20,),
                suffixIcon: _statusFilled
                    ? InkWell(
                        onTap: () {
                          clearSearch();
                        },
                        child: Icon(Icons.cancel, color: secondaryTextColor, size: 20,)
                      )
                    : null,
              ),
              onChanged: (value) {
                productProvider.searchProduct(value);
                if(value.isNotEmpty) {
                  _statusFilled = true;
                } else {
                  _statusFilled = false;
                }
              },
            ),
          );
        }
      );
    }

    Future<void> redirectToAuthDialog() async {
      return showDialog(
          context: context,
          builder: (BuildContext context) => const DirectToAuthDialog()
      );
    }

    Widget profile() {
      return Consumer<AuthProvider>(
          builder: (context, data, child) {
            return GestureDetector(
              onTap: () {
                data.user != null
                    ? Navigator.pushNamed(context, '/profile')
                    : redirectToAuthDialog();
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('assets/profile_image.png')),
                ),
              ),
            );
          }
      );
    }

    Widget headerContent() {
      return Container(
        margin: const EdgeInsets.only(
          top: 40.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<AuthProvider>(
              builder: (context, data, child) {
                return Text(
                  data.user != null ? 'Halo ${data.user!.name}!' : 'Halo!',
                  style: whiteTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold
                  )
                );
              }
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang di Budi Beras!',
                        style: whiteTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          color: Colors.white.withOpacity(0.25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_filled, color: secondaryColor,),
                              const SizedBox(width: 10,),
                              Flexible(
                                child: Text(
                                  'Buka: 07.00 - 17.00',
                                  style: whiteTextStyle
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                profile(),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    Future<void> refreshData() async{
      categoryProvider.categories = [];
      productProvider.products = [];

      //search field dikosongkan spy data utuh
      searchController.clear();
      productProvider.disposeSearch();

      await Future.wait([
        Provider.of<CategoryProvider>(context, listen: false).getCategories(),
        Provider.of<ProductProvider>(context, listen: false).getProducts(),
      ]);
    }

    Widget category() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              'Belanja berdasarkan Kategori',
              style: primaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, left: 20),
            child: Consumer2<CategoryProvider,ProductProvider>(
              builder: (context, data, productProv, child) {
                return SizedBox(
                  height: 45,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: data.categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        splashColor: fourthColor,
                        onTap: () {
                          //set category id
                          productProv.setCategoryId(data.categories[index].id);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ShopByCategoryPage(category: data.categories[index],)))
                            .then((_) {
                              setState(() {
                                productProvider.disposeSearch();
                                productProvider.disposeCategoryAndFilter();
                                productProvider.getProducts();
                              });
                            });
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
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
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 16);
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

    //NOTE: ukuran
    //==========================================================================
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeightWithBtn = (size.height -  kToolbarHeight) / 2;
    final double itemHeight = (size.height -  kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    double ratio1 = itemWidth/itemHeightWithBtn;
    double ratio2 = 1.2;

    double ratio3 = itemWidth/itemHeight;
    //==========================================================================

    Widget product() {
      return Consumer<ProductProvider>(
        builder: (context, data, child) {
          return GridView(
            padding: const EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: itemWidth <= itemHeightWithBtn ? ratio1 : ratio2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: data.products.where((e) => e.stockStatus.toLowerCase() == 'aktif').map(
                (product) => ProductCard(product: product)
            ).toList(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          );
        }
      );
    }

    Widget nonActiveProduct() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 1,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Text(
              'Produk Tidak Aktif / Stok Habis',
              style: greyTextStyle.copyWith(fontWeight: semiBold),
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, data, child) {
              return GridView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: itemWidth <= itemHeightWithBtn ? ratio3 : ratio2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: data.products.where((e) => e.stockStatus.toLowerCase() == 'tidak aktif').map(
                        (product) => InactiveProductCard(product: product)
                ).toList(),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              );
            }
          ),
        ],
      );
    }

    Widget productNotFound() {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Image.asset('assets/empty-icon.png', width: MediaQuery.of(context).size.width - (15 * defaultMargin),),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Mohon maaf, produk yang Anda cari tidak ditemukan',
                style: primaryTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 15
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: refreshData,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              expandedHeight: 210,
              collapsedHeight: 80,
              backgroundColor: primaryColor,
              pinned: true,
              snap: false,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: true,
                title: search(),
                background: headerContent(),
              ),
            ),
            Consumer2<CategoryProvider, ProductProvider>(
              builder: (context, categoryProvider, productProvider, child) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    categoryProvider.loading || productProvider.loading ?
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100.0),
                        child: CircularProgressIndicator(),
                      ),
                    ) :
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          category(),
                          productTitle(),
                          productProvider.products.isEmpty
                            ? productNotFound()
                            : Column(
                                children: [
                                  productProvider.products.any(
                                          (e) => e.stockStatus.toLowerCase() == 'aktif'
                                  ) ? product() : const SizedBox(),
                                  productProvider.products.any(
                                          (e) => e.stockStatus.toLowerCase() == 'tidak aktif'
                                  ) ? nonActiveProduct() : const SizedBox(),
                                ],
                            ),
                        ],
                      )
                    )
                  ])
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
