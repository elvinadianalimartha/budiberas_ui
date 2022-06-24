import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/services/cart_service.dart';

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
}