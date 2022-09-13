import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/views/widgets/product_card.dart';
import 'package:skripsi_budiberas_9701/views/widgets/product_inactive_card.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/app_bar.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../theme.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

class ShopByCategoryPage extends StatefulWidget {
  final CategoryModel category;

  const ShopByCategoryPage({
    Key? key,
    required this.category
  }) : super(key: key);

  @override
  State<ShopByCategoryPage> createState() => _ShopByCategoryPageState();
}

class _ShopByCategoryPageState extends State<ShopByCategoryPage> {
  late ProductProvider productProvider;
  TextEditingController searchController = TextEditingController(text: '');
  bool _statusFilled = false;

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    getInit();
  }

  getInit() async {
    productProvider.filterSizeProduct();
    productProvider.filterRiceCharacteristics();
  }

  @override
  void dispose() {
    super.dispose();
    productProvider.disposeFilter();
    productProvider.disposeSearchByCategory();
  }

  resetFilter() {
    productProvider.uncheckFilter();
  }

  void clearSearch() {
    searchController.clear();
    _statusFilled = false;
    productProvider.searchProductByCategory('');
  }

  @override
  Widget build(BuildContext context) {
    constants.size = MediaQuery.of(context).size;

    sortPrice() {
      return Consumer<ProductProvider>(
          builder: (context, productProv, child) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(thickness: 1),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 16),
                    child: Text(
                      'Urutkan Harga',
                      style: primaryTextStyle.copyWith(fontWeight: semiBold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        Flexible(
                          child: RadioListTile<int>(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                            value: 1,
                            groupValue: productProv.selectedPriceSort,
                            onChanged: (value) {
                              productProv.changeDefaultVal(value!);
                            },
                            title: Text('Termurah', style: primaryTextStyle.copyWith(fontSize: 14),),
                            activeColor: priceColor,
                          ),
                        ),
                        Flexible(
                          child: RadioListTile<int>(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                            value: 0,
                            groupValue: productProv.selectedPriceSort,
                            onChanged: (value) {
                              productProv.changeDefaultVal(value!);
                            },
                            title: Text('Termahal', style: primaryTextStyle.copyWith(fontSize: 14)),
                            activeColor: priceColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ]
            );
          }
      );
    }
    
    listFilterSize() {
      return Consumer<ProductProvider>(
        builder: (context, productProv, child) {
          List<double> sizeFiltersTitle = productProv.sizes.map((e) => e.title as double).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 16),
                child: Text(
                  'Ukuran',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: productProv.sizes.length,
                  itemBuilder: (context, index) {
                    double sizeByIdx = sizeFiltersTitle[index];
                    num formattedSize;
                    var decimalNumber = sizeByIdx % 1; //get decimal value (angka di belakang koma)
                    if(decimalNumber == 0) {
                      formattedSize = sizeByIdx.toInt(); //remove .0
                    } else {
                      formattedSize = sizeByIdx;
                    }
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return CheckboxListTile(
                          activeColor: primaryColor,
                          onChanged: (bool? value) {
                            setModalState(() {
                              productProv.sizes[index].value = value!;
                            });

                            if(productProv.sizes[index].value == true) {
                              productProv.addFilterSize(sizeByIdx);
                            } else {
                              productProv.removeFilterSize(sizeByIdx);
                            }
                          },
                          value: productProv.sizes[index].value,
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(
                            '${formattedSize.toString()} kg/L',
                            style: primaryTextStyle.copyWith(fontSize: 14),
                          ),
                        );
                      }
                    );
                  }
              ),
            ]
          );
        }
      );
    }

    listFilterRice() {
      return Consumer<ProductProvider>(
        builder: (context, productProv, child) {
          List<String> riceFiltersTitle = productProv.characteristics.map((e) => e.title as String).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 1,),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 16),
                child: Text(
                  'Karakteristik Beras',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productProv.characteristics.length,
                itemBuilder: (context, index) {
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return CheckboxListTile(
                        activeColor: primaryColor,
                        onChanged: (bool? value) {
                          setModalState(() {
                            productProv.characteristics[index].value = value!;
                          });

                          if(productProv.characteristics[index].value == true) {
                            productProv.addFilterRice(riceFiltersTitle[index]);
                          } else {
                            productProv.removeFilterRice(riceFiltersTitle[index]);
                          }
                        },
                        value: productProv.characteristics[index].value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          riceFiltersTitle[index],
                          style: primaryTextStyle.copyWith(fontSize: 14),
                        ),
                      );
                    },
                  );
                }
              ),
            ],
          );
        }
      );
    }

    Future<void> showModalFilter() {
      return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter ${widget.category.categoryName}',
                        style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          resetFilter();
                        },
                        child: Text(
                          'Reset Filter',
                          style: orderNotesTextStyle.copyWith(decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),

                listFilterSize(),

                widget.category.categoryName.toLowerCase().contains('beras')
                    ? listFilterRice()
                    : const SizedBox(),

                sortPrice(),

                const SizedBox(height: 20,),
                SizedBox(
                  width: MediaQuery.of(context).size.width - defaultMargin*2,
                  child: DoneButton(
                    text: 'Terapkan Filter',
                    onClick: () {
                      productProvider.checkProductMeetFilter();
                      if(productProvider.selectedPriceSort != null) {
                        productProvider.sortByPrice();
                      }
                      Navigator.pop(context);
                      print(productProvider.selectedFilterRiceChar.map((e) => e as String).toList());
                      print(productProvider.productMeetFilter);
                    },
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            )
          )
        ),
      );
    }
    
    Widget filterBtn() {
      return GestureDetector(
        onTap: () {
          showModalFilter();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: secondaryColor,
          ),
          width: MediaQuery.of(context).size.width/4 - 12,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.filter_list_alt, color: Colors.white,),
              const SizedBox(width: 8,),
              Flexible(
                child: Text(
                  'Filter',
                  style: whiteTextStyle.copyWith(fontSize: 14),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget search() {
      return Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return TextFormField(
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
                    borderSide: BorderSide(color: secondaryTextColor)
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
              onChanged: (value) { //onChanged atau onSubmitted enaknya?
                productProvider.searchProductByCategory(value);
                if(value.isNotEmpty) {
                  _statusFilled = true;
                } else {
                  _statusFilled = false;
                }
              },
            );
          }
      );
    }

    Widget activeProduct(List<ProductModel> listActiveProducts) {
      return GridView(
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: constants.itemWidth <= constants.itemHeightWithBtn ? constants.ratio1 : constants.ratio2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: listActiveProducts.where((e) => e.stockStatus.toLowerCase() == 'aktif').map(
                (product) => ProductCard(product: product)
        ).toList(),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      );
    }

    Widget nonActiveProduct(List<ProductModel> listNonActiveProducts) {
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
          GridView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: constants.itemWidth <= constants.itemHeightWithBtn ? constants.ratio3 : constants.ratio2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: listNonActiveProducts.where((e) => e.stockStatus.toLowerCase() == 'tidak aktif').map(
                    (product) => InactiveProductCard(product: product)
            ).toList(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          )
        ],
      );
    }

    Widget productNotFound() {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 50,),
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

    Widget filteredProductNotFound() {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Image.asset('assets/empty-icon.png', width: MediaQuery.of(context).size.width - (15 * defaultMargin),),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Text(
                    'Mohon maaf, produk yang Anda filter tidak ditemukan',
                    style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 15
                    ),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {
                      resetFilter();
                    },
                    child: Text(
                      'Reset Filter',
                      style: orderNotesTextStyle.copyWith(fontSize: 16, decoration: TextDecoration.underline),
                    )
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      );
    }

    Widget allProducts() {
      return Column(
        children: [
          productProvider.productByCategory.any(
                  (e) => e.stockStatus.toLowerCase() == 'aktif'
          ) ? activeProduct(productProvider.productByCategory) : const SizedBox(),
          productProvider.productByCategory.any(
                  (e) => e.stockStatus.toLowerCase() == 'tidak aktif'
          ) ? nonActiveProduct(productProvider.productByCategory) : const SizedBox(),
        ],
      );
    }

    Widget filteredProducts() {
      return Column(
        children: [
          productProvider.productMeetFilter.any(
                  (e) => e.stockStatus.toLowerCase() == 'aktif'
          ) ? activeProduct(productProvider.productMeetFilter) : const SizedBox(),
          productProvider.productMeetFilter.any(
                  (e) => e.stockStatus.toLowerCase() == 'tidak aktif'
          ) ? nonActiveProduct(productProvider.productMeetFilter) : const SizedBox(),
        ],
      );
    }

    Widget content(ProductProvider productProvider) {
      return productProvider.selectedFilterSize.isEmpty && productProvider.selectedFilterRiceChar.isEmpty
        ? allProducts()
        : productProvider.productMeetFilter.isEmpty
          ? filteredProductNotFound()
          : filteredProducts();
    }

    return Scaffold(
      appBar: customAppBar(text: 'Produk Kategori ${widget.category.categoryName}'),
      body: SingleChildScrollView(
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        filterBtn(),
                        const SizedBox(width: 16,),
                        Flexible(child: search())
                      ],
                    ),
                  ),
                  productProvider.productByCategory.isEmpty
                      ? productNotFound()
                      : content(productProvider)
                ],
              );
            }
          )
      )
    );
  }
}
