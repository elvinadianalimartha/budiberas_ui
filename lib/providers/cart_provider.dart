import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pusher_client/pusher_client.dart';
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

  List<CartModel> _cartSelected = [];

  List<CartModel> get cartSelected => _cartSelected;

  set cartSelected(List<CartModel> value) {
    _cartSelected = value;
    notifyListeners();
  }

  bool _checkAll = false;

  bool get checkAll => _checkAll;

  set checkAll(bool value) {
    _checkAll = value;
    notifyListeners();
  }

  Future<void> pusherStock() async {
    PusherClient pusher;
    Channel channel;
    pusher = PusherClient('2243680746c2e59ee156', PusherOptions(cluster: 'ap1'));

    channel = pusher.subscribe('stock-updated');

    channel.bind('App\\Events\\StockUpdated', (event) {
      print(event!.data);
      final data = jsonDecode(event.data!);

      var productIdToUpdate = int.parse(data['productId'].toString());

      _carts.where(
            (cart) => cart.product.id == productIdToUpdate
      ).first.product.stock = data['stockQty'];
      notifyListeners();

      //kalau melebihi jml stok, maka diupdate jadi sama dgn stok saat ini
      if(data['stockQty'] > 0) {
        if(_carts.where(
                (cart) => cart.product.id == productIdToUpdate
        ).first.quantity > data['stockQty']) {
          _carts.where(
                  (cart) => cart.product.id == productIdToUpdate
          ).first.quantity = data['stockQty'];
          notifyListeners();
        }
      }
    });
  }

  Future<void> pusherProductStatus() async {
    PusherClient pusher;
    Channel channel;
    pusher = PusherClient('2243680746c2e59ee156', PusherOptions(cluster: 'ap1'));

    channel = pusher.subscribe('product-status');

    channel.bind('App\\Events\\ProductStatusUpdated', (event) {
      print(event!.data);
      final data = jsonDecode(event.data!);

      var productIdToUpdate = int.parse(data['productId'].toString());

      //update data status sesuai dgn id yg dituju
      _carts.where(
          (e) => e.product.id == productIdToUpdate)
      .first.product.stockStatus = data['productStatus'];

      //Jika status produk tdk aktif, akan dihapus dari cartSelected/cart yg terpilih
      //Sebaliknya, jika aktif kembali dan isSelected true, akan kembali ke cartSelected spy bisa otomatis menyesuaikan perhitungan totalnya
      CartModel _updatedCart = _carts.where(
          (e) => e.product.id == productIdToUpdate
      ).first;

      if(_updatedCart.isSelected == true) {
        if(data['productStatus'].toString().toLowerCase() == 'tidak aktif') {
          _cartSelected.removeWhere(
              (e) => e.product.id == productIdToUpdate
          );
        } else if(data['productStatus'].toString().toLowerCase() == 'aktif') {
          //jika blm ada di list selected cart, maka masukkan
          if(!cartIdExistInSelectedCart(_updatedCart.id)) {
            _cartSelected.add(_updatedCart);
          }
        }
      }
      notifyListeners();
    });
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

  setCheckAllValue() {
    List<CartModel> _activeCarts = _carts.where((cart) => cart.product.stockStatus.toLowerCase() == 'aktif').toList();
    _checkAll = _activeCarts.every((item) => item.isSelected);
    notifyListeners();
  }

  initSelectedCartData() {
    _cartSelected = _carts.where((cart) => cart.isSelected == true && cart.product.stockStatus.toLowerCase() == 'aktif').toList();

    //init check all value
    setCheckAllValue();

    notifyListeners();
  }

  countTotalPrice() {
    double total = 0;
    for(var item in _cartSelected) {
      total += (item.quantity * item.product.price);
    }
    return total;
  }

  //add to _cartSelected (when checkbox is true)
  selectCart(CartModel cartModel) {
    _cartSelected.add(cartModel);
    notifyListeners();
  }

  removeFromSelectedCart(int idCart) {
    _cartSelected.removeWhere(
            (cart) => cart.id == idCart
    );
    notifyListeners();
  }

  cartIdExistInSelectedCart(int idCart) {
    bool existVal = _cartSelected.any((cart) => cart.id == idCart);
    return existVal;
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

  Future<bool> updateValSelectedCart({
    required int id,
    required String token,
    required int isSelected,
  }) async {
    try {
      if(await CartService().updateValSelectedCart(id: id, token: token, isSelected: isSelected)){
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateValSelectedCartAll({
    required String token,
    required int isSelected,
  }) async {
    try {
      if(await CartService().updateValSelectedCartAll(token: token, isSelected: isSelected)){
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  manualEditQty(int id, int newQty) {
    int index = _carts.indexWhere((cart) => cart.id == id);
    _carts[index].quantity = newQty;

    if(cartIdExistInSelectedCart(id)) {
      int idSelected = _cartSelected.indexWhere((cart) => cart.id == id);
      _cartSelected[idSelected].quantity = _carts[index].quantity;
    }
    notifyListeners();
  }

  //update quantity on cart (include increment, decrement, edit manual)
  incrementQty(int id) {
    int index = _carts.indexWhere((cart) => cart.id == id);
    _carts[index].quantity++;

    if(cartIdExistInSelectedCart(id)) {
      int idSelected = _cartSelected.indexWhere((cart) => cart.id == id);
      _cartSelected[idSelected].quantity = _carts[index].quantity;
    }
    notifyListeners();
  }

  decrementQty(int id) {
    int index = _carts.indexWhere((cart) => cart.id == id);
    _carts[index].quantity--;

    if(cartIdExistInSelectedCart(id)) {
      int idSelected = _cartSelected.indexWhere((cart) => cart.id == id);
      _cartSelected[idSelected].quantity = _carts[index].quantity;
    }
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

  //order notes
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

  //delete cart
  removeCart(int id) {
    if(_carts.isNotEmpty) {
      _carts.removeWhere((element) => element.id == id);
      notifyListeners();
    }

    if(_cartSelected.isNotEmpty) {
      _cartSelected.removeWhere((element) => element.id == id);
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