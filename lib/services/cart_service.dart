import 'dart:convert';

import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:skripsi_budiberas_9701/models/cart_model.dart';
import 'package:http/http.dart' as http;

class CartService{
  String baseUrl = constants.baseUrl;

  Future<List<CartModel>> getCartsByUser() async{
    var url = '$baseUrl/carts';
    String token = await constants.getTokenUser();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      List<CartModel> carts = [];

      for(var item in data) {
        carts.add(CartModel.fromJson(item));
      }

      return carts;
    } else {
      throw Exception('Data keranjang gagal diambil!');
    }
  }

  Future<bool> addToCart({
    required String token,
    required int productId,
  }) async {
    var url = '$baseUrl/cart';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'product_id': productId,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Produk gagal dimasukkan ke keranjang');
    }
  }

  Future<bool> updateQty({
    required int id,
    required String token,
    required int quantity,
  }) async {
    var url = '$baseUrl/qtyCart/$id';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'quantity': quantity,
    });

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Jumlah produk dalam keranjang gagal diperbarui');
    }
  }

  Future<bool> updateOrderNotes({
    required int id,
    required String token,
    required String orderNotes,
  }) async {
    var url = '$baseUrl/noteInCart/$id';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'order_notes': orderNotes,
    });

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Catatan pesanan gagal disimpan');
    }
  }

  Future<bool> deleteCart({
    required int id,
    required String token,
  }) async {
    var url = '$baseUrl/cart/$id';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Data keranjang gagal dihapus');
    }
  }

  Future<bool> updateValSelectedCart({
    required int id,
    required String token,
    required int isSelected,
  }) async {
    var url = '$baseUrl/cartIsSelected/$id';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'is_selected': isSelected,
    });

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Keranjang yang terpilih gagal diperbarui');
    }
  }

  Future<bool> updateValSelectedCartAll({
    required String token,
    required int isSelected,
  }) async {
    var url = '$baseUrl/allCartIsSelected';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'is_selected': isSelected,
    });

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Semua keranjang yang terpilih gagal diperbarui');
    }
  }

  //NOTE: for order confirmation page
  Future<List<CartModel>> getSelectedCart({required String token}) async{
    var url = '$baseUrl/selectedCart';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      List<CartModel> selectedCarts = [];

      for(var item in data) {
        selectedCarts.add(CartModel.fromJson(item));
      }

      return selectedCarts;
    } else {
      throw Exception('Data keranjang terpilih gagal diambil!');
    }
  }
}