import 'dart:convert';

import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;

class CheckoutService{
  String baseUrl = constants.baseUrl;

  Future<String> checkout({
    required String token,
    String? orderReceiver,
    String? phoneNumber,
    String? address,
    String? detailAddress,
    required String shippingType,
    required double shippingRate,
    required double totalPrice,
  }) async {
    var url = '$baseUrl/checkout';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'order_receiver': orderReceiver,
      'phone_number': phoneNumber,
      'address': address,
      'detail_address': detailAddress,
      'shipping_type': shippingType,
      'shipping_rate': shippingRate,
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

  Future<bool> savePaymentInfo({
    required String token,
    required String midtransOrderId,
    required String paymentMethod,
    String? bankName,
    String? vaNumber,
    required String transactionStatus,
  }) async {
    var url = '$baseUrl/savePaymentInfo';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'midtrans_order_id': midtransOrderId,
      'payment_method': paymentMethod,
      'bank_name': bankName,
      'va_number': vaNumber,
      'transaction_status': transactionStatus,
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