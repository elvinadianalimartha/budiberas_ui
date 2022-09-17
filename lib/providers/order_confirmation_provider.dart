import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/services/cart_service.dart';
import 'package:skripsi_budiberas_9701/services/checkout_service.dart';

import '../models/cart_model.dart';
import '../models/user_model.dart';

class OrderConfirmationProvider with ChangeNotifier{
  UserModel? _user;

  set user(UserModel? userVal) {
    _user = userVal;
    notifyListeners();
  }

  List<CartModel> _selectedCartsFromServer = [];

  List<CartModel> get selectedCartsFromServer => _selectedCartsFromServer;

  set selectedCartsFromServer(List<CartModel> value) {
    _selectedCartsFromServer = value;
    notifyListeners();
  }

  bool loadingGetSelectedCarts = false;

  Future<void> getSelectedCarts() async {
    loadingGetSelectedCarts = true;
    try {
      List<CartModel> selectedCarts = await CartService().getSelectedCart(token: _user!.token!);
      _selectedCartsFromServer = selectedCarts;
    } catch (e) {
      print(e);
    }
    loadingGetSelectedCarts = false;
    notifyListeners();
  }

  confirmCountTotalPrice() {
    double total = 0;
    for(var item in _selectedCartsFromServer) {
      total += (item.quantity * item.product.price);
    }
    return total;
  }

  String _snapToken = '';

  String get snapToken => _snapToken;

  set snapToken(String value) {
    _snapToken = value;
    notifyListeners();
  }

  bool loadingCheckout = false;

  Future<bool> checkout({
    required double totalPrice,
    String? orderReceiver,
    String? phoneNumber,
    String? address,
    String? detailAddress,
    required String shippingType,
    required double shippingRate,
  }) async{
    try {
      _snapToken = '';
      String link = await CheckoutService().checkout(
        token: _user!.token!,
        totalPrice: totalPrice,
        orderReceiver: orderReceiver,
        phoneNumber: phoneNumber,
        address: address,
        detailAddress: detailAddress,
        shippingType: shippingType,
        shippingRate: shippingRate,
      ); //checkout akan mereturn snap token -> ditampung di var link
      _snapToken = link;
      if(_snapToken != '') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> savePaymentInfo({
    required String midtransOrderId,
    required String paymentMethod,
    String? bankName,
    String? vaNumber,
    required String transactionStatus,
}) async{
    try {
      if(await CheckoutService().savePaymentInfo(
          token: _user!.token!,
          midtransOrderId: midtransOrderId,
          paymentMethod: paymentMethod,
          bankName: bankName,
          vaNumber: vaNumber,
          transactionStatus: transactionStatus,
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