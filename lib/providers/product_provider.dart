import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:skripsi_budiberas_9701/models/product_model.dart';
import 'package:skripsi_budiberas_9701/services/product_service.dart';

class CheckboxFilterState{
  dynamic title;
  bool value;

  CheckboxFilterState({
    required this.title,
    this.value = false
  });
}

class ProductProvider with ChangeNotifier{
  List<ProductModel> _products = [];
  bool loading = false;
  String _searchQuery = '';

  List<ProductModel> get products => _searchQuery.isEmpty
      ? _products
      : _products.where(
          (product) => product.name.toLowerCase().contains(_searchQuery)
      ).toList();

  set products(List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }

  int _currentIndexImg = 0;

  int get currentIndexImg => _currentIndexImg;

  set currentIndexImg(int value) {
    _currentIndexImg = value;
    notifyListeners();
  }

  //============================================================================
  void disposeIndexImgValue() {
    _currentIndexImg = 0;
  }

  void disposeSearch() {
    _searchQuery = '';
  }

  Future<void> getProducts({
    int? categoryId,
    String? search,
  }) async{
    loading = true;
    try{
      List<ProductModel> products = await ProductService().getProducts(
        categoryId: shopByCategoryId,
        search: search,
        size: selectedFilterSize,
        riceChar: selectedFilterRiceChar,
        sortByPrice: selectedSortByPrice
      );
      _products = products;
    }catch(e) {
      print(e);
      _products = [];
    }
    loading = false;
    notifyListeners();
  }

  //============================================================================

  int? shopByCategoryId;
  setCategoryId(int categoryId) {
    shopByCategoryId = categoryId;
    notifyListeners();
  }

  //============================================================================
  Future<void> pusherProductStatus() async {
    PusherClient pusher;
    Channel channel;
    pusher = PusherClient('2243680746c2e59ee156', PusherOptions(cluster: 'ap1'));

    channel = pusher.subscribe('product-status');

    channel.bind('App\\Events\\ProductStatusUpdated', (event) {
      print(event!.data);
      final data = jsonDecode(event.data!);

      //update data status sesuai dgn id yg dituju
      _products.where((e) => e.id == int.parse(data['productId'].toString())).first.stockStatus = data['productStatus'];
      notifyListeners();
    });
  }

  void searchProduct(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  //============================== CLEAR FILTER ================================
  disposeCategoryAndFilter() {
    shopByCategoryId = null;

    setSizeDone = false;
    sizes = [];
    characteristics = [];

    selectedFilterSize.clear();
    selectedFilterRiceChar.clear();

    selectedSortByPrice = null;
  }

  uncheckFilter() {
    for(var char in characteristics) {
      char.value = false;
    }
    for(var size in sizes) {
      size.value = false;
    }
    selectedFilterSize.clear();
    selectedFilterRiceChar.clear();
    selectedSortByPrice = null;
    notifyListeners();
  }

  //================ SET SIZE LIST FILTER (BASED ON CATEGORY) ================
  List<CheckboxFilterState> sizes = [];
  bool setSizeDone = false;

  filterSizeProduct() {
    //product by category take ukuran, group by
    for (var product in _products) {
      bool isSizeExist = sizes.any((e) => e.title == product.size);
      if(!isSizeExist) {
        sizes.add(CheckboxFilterState(title: product.size));
      }
    }
    setSizeDone = true;
  }

  //================ SET RICE CHARACTERISTICS FILTER ========================
  List<CheckboxFilterState> characteristics = [];

  filterRiceCharacteristics() {
    characteristics = [
      CheckboxFilterState(title: 'Pera'),
      CheckboxFilterState(title: 'Pulen')
    ];
  }

  //========================== SET PRICE SORTING =============================
  int? selectedSortByPrice;

  void changeSortVal(int value) {
    selectedSortByPrice = value;
    notifyListeners();
  }

  //********************* SELECT FILTER (Checkbox Clicked) *******************
  List<double> selectedFilterSize = [];
  List<String> selectedFilterRiceChar = [];

  addFilterSize(double size) {
    selectedFilterSize.add(size);
    notifyListeners();
  }

  removeFilterSize(double size) {
    selectedFilterSize.remove(size);
    notifyListeners();
  }

  addFilterRice(String char) {
    selectedFilterRiceChar.add(char);
    notifyListeners();
  }

  removeFilterRice(String char) {
    selectedFilterRiceChar.remove(char);
    notifyListeners();
  }
}