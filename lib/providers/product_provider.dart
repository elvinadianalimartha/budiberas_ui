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

  Future<void> getProducts() async{
    loading = true;
    try{
      List<ProductModel> products = await ProductService().getProducts();
      _products = products;
    }catch(e) {
      print(e);
    }
    loading = false;
    notifyListeners();
  }

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

  //============================= PRODUCT BY CATEGORY ==========================
  List<ProductModel> _productByCategory = [];
  String _searchQueryOnCategory = '';

  List<ProductModel> get productByCategory => _searchQueryOnCategory.isEmpty
      ? _productByCategory
      : _productByCategory.where((e) => e.name.toLowerCase().contains(_searchQueryOnCategory)).toList();

  set productByCategory(List<ProductModel> value) {
    _productByCategory = value;
    notifyListeners();
  }

  setProductByCategory(int categoryId) {
    _productByCategory = _products.where((e) => e.category.id == categoryId).toList();
  }

  //======================= SEARCH PRODUCT BY CATEGORY =========================
  void searchProductByCategory(String query) {
    _searchQueryOnCategory = query.toLowerCase();
    notifyListeners();
  }

  void disposeSearchByCategory() {
    _searchQueryOnCategory = '';
  }

  //============================== CLEAR FILTER ================================
  disposeFilter() {
    sizes = [];
    characteristics = [];

    selectedFilterSize = [];
    selectedFilterRiceChar = [];

    _productMeetFilter = [];

    selectedPriceSort = null;
  }

  uncheckFilter() {
    for(var char in characteristics) {
      char.value = false;
    }
    for(var size in sizes) {
      size.value = false;
    }
    selectedFilterSize = [];
    selectedFilterRiceChar = [];
    _productMeetFilter = [];
    selectedPriceSort = null;
    notifyListeners();
  }

  //================ SET SIZE LIST FILTER (BASED ON CATEGORY) ================
  List<CheckboxFilterState> sizes = [];

  filterSizeProduct() {
    //product by category take ukuran, group by
    for (var product in _productByCategory) {
      bool isSizeExist = sizes.any((e) => e.title == product.size);
      if(!isSizeExist) {
        sizes.add(CheckboxFilterState(title: product.size));
      }
    }
    print(sizes);
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
  int? selectedPriceSort;

  void changeDefaultVal(int value) {
    selectedPriceSort = value;
    notifyListeners();
  }

  sortByPrice() {
    //dari yg termurah
    if(selectedPriceSort == 1) {
      _productByCategory.sort((a, b) => a.price.compareTo(b.price));
      _productMeetFilter.sort((a, b) => a.price.compareTo(b.price));
    }

    //dari yg termahal
    if(selectedPriceSort == 0) {
      _productByCategory.sort((b, a) => a.price.compareTo(b.price));
      _productMeetFilter.sort((b, a) => a.price.compareTo(b.price));
    }
    notifyListeners();
  }

  //********************* SELECT FILTER (Checkbox Clicked) *******************
  List selectedFilterSize = [];
  List selectedFilterRiceChar = [];

  addFilterSize(double size) {
    selectedFilterSize.add(size);
    notifyListeners();
  }

  removeFilterSize(double size) {
    selectedFilterSize.remove(size);
    _productMeetFilter.removeWhere((e) => e.size == size);
    notifyListeners();
  }

  addFilterRice(String char) {
    selectedFilterRiceChar.add(char);
    notifyListeners();
  }

  removeFilterRice(String char) {
    selectedFilterRiceChar.remove(char);
    _productMeetFilter.removeWhere((e) => e.description.toLowerCase().contains(char.toLowerCase()));
    notifyListeners();
  }

  //================ SET PRODUCT LIST THAT MEET SELECTED FILTERS ===============
  List<ProductModel> _productMeetFilter = [];

  List<ProductModel> get productMeetFilter => _searchQueryOnCategory.isEmpty
      ? _productMeetFilter
      : _productMeetFilter.where((e) => e.name.toLowerCase().contains(_searchQueryOnCategory)).toList();

  set productMeetFilter(List<ProductModel> value) {
    _productMeetFilter = value;
    notifyListeners();
  }

  checkProductMeetFilter() {
    isExistRiceInList(dynamic filterRice) {
      bool isExistRice = _productMeetFilter.any((e) => e.description.toLowerCase().contains(filterRice.toLowerCase()));
      return isExistRice;
    }

    isExistSizeInList(dynamic filterSize) {
      bool isExistSize = _productMeetFilter.any((e) => e.size == filterSize);
      return isExistSize;
    }

    if(selectedFilterRiceChar.isNotEmpty && selectedFilterSize.isNotEmpty) {
      _productMeetFilter = [];
      for (var filterRice in selectedFilterRiceChar) {
        bool isExistRice = isExistRiceInList(filterRice);

        for (var filterSize in selectedFilterSize) {
          bool isExistSize = isExistSizeInList(filterSize);

          if (!isExistRice && !isExistSize) {
            _productMeetFilter = _productMeetFilter + _productByCategory
                .where((e) => e.description.toLowerCase().contains(filterRice.toLowerCase()) && e.size == filterSize)
                .toList();
          }
        }
      }
    }

    if(selectedFilterSize.isEmpty) {
      if(selectedFilterRiceChar.isNotEmpty) {
        _productMeetFilter = [];
        for(var filterRice in selectedFilterRiceChar) {
          bool isExistRice = isExistRiceInList(filterRice);

          if(!isExistRice) {
            _productMeetFilter = _productMeetFilter + _productByCategory
                .where((e) => e.description.toLowerCase().contains(filterRice.toLowerCase())).toList();
          }
        }
      }
    }

    if(selectedFilterRiceChar.isEmpty) {
      if(selectedFilterSize.isNotEmpty) {
        _productMeetFilter = [];
        for(var filterSize in selectedFilterSize) {
          bool isExistSize = isExistSizeInList(filterSize);

          if(!isExistSize) {
            _productMeetFilter = _productMeetFilter + _productByCategory.where((e) => e.size == filterSize).toList();
          }
        }
      }
    }
    notifyListeners();
  }
}