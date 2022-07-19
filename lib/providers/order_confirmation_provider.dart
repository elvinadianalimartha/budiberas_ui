import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/services/cart_service.dart';
import 'package:skripsi_budiberas_9701/services/checkout_service.dart';

import '../models/cart_model.dart';
import '../models/user_model.dart';

class OrderConfirmationProvider with ChangeNotifier{
  late UserModel _user;

  set user(UserModel userVal) {
    _user = userVal;
    notifyListeners();
  }

  List<CartModel> _selectedCartsFromServer = [];

  List<CartModel> get selectedCartsFromServer => _selectedCartsFromServer;

  set selectedCartsFromServer(List<CartModel> value) {
    _selectedCartsFromServer = value;
    notifyListeners();
  }

  bool loadingGetData = false;

  Future<void> getSelectedCarts() async {
    loadingGetData = true;
    try {
      List<CartModel> selectedCarts = await CartService().getSelectedCart(token: _user.token!);
      _selectedCartsFromServer = selectedCarts;
    } catch (e) {
      print(e);
    }
    loadingGetData = false;
    notifyListeners();
  }

  confirmCountTotalPrice() {
    double total = 0;
    for(var item in _selectedCartsFromServer) {
      total += (item.quantity * item.product.price);
    }
    return total;
  }

  String _redirectLink = '';

  String get redirectLink => _redirectLink;

  set redirectLink(String value) {
    _redirectLink = value;
    notifyListeners();
  }

  bool loadingCheckout = false;

  Future<bool> checkout({
    required double totalPrice,
  }) async{
    try {
      _redirectLink = '';
      String link = await CheckoutService().checkout(
          token: _user.token!,
          totalPrice: totalPrice);
      _redirectLink = link;
      if(_redirectLink != '') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> saveTransaction({
    int? userDetailId,
    required double shippingRate,
    required String shippingType,
    required double totalPrice,
    required String invoiceCode,
    required String paymentMethod,
}) async{
    try {
      if(await CheckoutService().saveTransaction(
          token: _user.token!,
          userDetailId: userDetailId,
          shippingRate: shippingRate,
          shippingType: shippingType,
          totalPrice: totalPrice,
          invoiceCode: invoiceCode,
          paymentMethod: paymentMethod,
      )) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}