import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';

class MessageProvider with ChangeNotifier{
  ProductModel _linkedProduct = UninitializedProductModel();

  ProductModel get linkedProduct => _linkedProduct;

  set linkedProduct(ProductModel value) {
    _linkedProduct = value;
    notifyListeners();
  }

  void resetToUninitialized() {
    _linkedProduct = UninitializedProductModel();
  }
}