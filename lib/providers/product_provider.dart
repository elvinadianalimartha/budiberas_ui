import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:skripsi_budiberas_9701/models/product_model.dart';
import 'package:skripsi_budiberas_9701/services/product_service.dart';

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
}