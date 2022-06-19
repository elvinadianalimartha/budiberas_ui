import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/services/cart_service.dart';

import '../models/cart_model.dart';

class CartProvider with ChangeNotifier{
  List<CartModel> _carts = [];

  List<CartModel> get carts => _carts;

  bool loadingGetCart = false;

  set carts(List<CartModel> value) {
    _carts = value;
    notifyListeners();
  }

  Future<void> getCartsByUser(String token) async{
    loadingGetCart = true;
    try {
      List<CartModel> carts = await CartService().getCartsByUser(token);
      _carts = carts;
    } catch (e) {
      print(e);
    }
    loadingGetCart = false;
    notifyListeners();
  }

  totalPrice() {
    double total = 0;
    for(var item in _carts) {
      total += (item.quantity * item.product.price);
    }
    return total;
  }

  Future<bool> addToCart({
    required String token,
    required int productId,
  }) async {
    try {
      if(await CartService().addToCart(token: token, productId: productId)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  //update quantity on cart (include increment, decrement, edit manual)
  incrementQty(int id) {
    _carts.where((element) => element.id == id).forEach((cart) {
      cart.quantity++;
    });
    notifyListeners();
  }

  decrementQty(int id) {
    _carts.where((element) => element.id == id).forEach((cart) {
      cart.quantity--;
    });
    notifyListeners();
  }

  Future<bool> updateQtyCart({
    required int id,
    required String token,
    required int quantity,
  }) async {
    try {
      if(await CartService().updateQty(id: id, quantity: quantity, token: token)){
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  clickShowTextForm(int id) {
    _carts.where((element) => element.id == id).forEach((cart) {
      cart.noteIsNull = false;
    });
    notifyListeners();
  }

  clickToRemoveForm(int id) {
    _carts.where((element) => element.id == id).forEach((cart) {
      cart.noteIsNull = true;
    });
    notifyListeners();
  }

  Future<bool> updateOrderNotes({
    required int id,
    required String token,
    required String orderNotes,
  }) async {
    try {
      if(await CartService().updateOrderNotes(id: id, orderNotes: orderNotes, token: token)){
        _carts.where((element) => element.id == id).forEach((cart) {
          cart.orderNotes = orderNotes;
        });
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  removeCart(int id) {
    if(_carts.isNotEmpty) {
      _carts.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }

  Future<bool> deleteCart({
    required int id,
    required String token,
  }) async {
    try {
      if(await CartService().deleteCart(id: id, token: token)){
        removeCart(id);
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