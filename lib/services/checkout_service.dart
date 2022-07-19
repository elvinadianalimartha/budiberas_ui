import 'dart:convert';

import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;

class CheckoutService{
  String baseUrl = constants.baseUrl;

  Future<String> checkout({
    required String token,
    required double totalPrice,
  }) async {
    var url = '$baseUrl/checkout';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'total_price': totalPrice,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    return response.body;
  }

  Future<bool> saveTransaction({
    required String token,
    int? userDetailId,
    required double shippingRate,
    required String shippingType,
    required String invoiceCode,
    required double totalPrice,
    required String paymentMethod,
  }) async {
    var url = '$baseUrl/saveTransaction';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'user_detail_id': userDetailId,
      'shipping_rate': shippingRate,
      'shipping_type': shippingType,
      'invoice_code': invoiceCode,
      'total_price': totalPrice,
      'payment_method': paymentMethod,
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
      throw Exception('Gagal checkout');
    }
  }
}